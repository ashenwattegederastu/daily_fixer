package com.dailyfixer.product;

import com.dailyfixer.dao.ProductDAO;
import com.dailyfixer.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@WebServlet("/AddProductServlet")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class AddProductServlet extends HttpServlet {
    private static final String UPLOAD_DIR = "assets" + File.separator + "uploads" + File.separator + "products";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // 1. Get User Session
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("currentUser");
            if (user == null || !"store".equals(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }

            // 2. Parse Basic Fields
            Product p = new Product();
            p.setStoreUsername(user.getUsername());
            p.setName(request.getParameter("name"));
            p.setBrand(request.getParameter("brand"));
            p.setDescription(request.getParameter("description"));
            p.setBasePrice(Double.parseDouble(request.getParameter("basePrice")));
            p.setCategoryMain(request.getParameter("categoryMain"));
            p.setCategorySub(request.getParameter("categorySub"));
            p.setCategoryOther(request.getParameter("categoryOther")); // Optional
            p.setWarrantyInfo(request.getParameter("warrantyInfo"));
            p.setStockStatus("ACTIVE");

            // 3. Handle Image Upload
            // Saves to /webapp/assets/uploads/products
            Part filePart = request.getPart("image");
            if (filePart != null && filePart.getSize() > 0) {
                String applicationPath = request.getServletContext().getRealPath("");
                String uploadFilePath = applicationPath + File.separator + UPLOAD_DIR;

                File uploadDir = new File(uploadFilePath);
                if (!uploadDir.exists())
                    uploadDir.mkdirs();

                String fileName = java.util.UUID.randomUUID().toString() + "_" + getFileName(filePart);
                filePart.write(uploadFilePath + File.separator + fileName);

                ProductImage mainImage = new ProductImage();
                // Store relative path for frontend access
                mainImage.setImagePath(UPLOAD_DIR.replace(File.separator, "/") + "/" + fileName);
                mainImage.setMain(true);

                List<ProductImage> imgs = new ArrayList<>();
                imgs.add(mainImage);
                p.setImages(imgs);
            }

            // 4. Parse Attributes
            // Expecting params like: attrNames[], attrValues[]
            String[] attrNames = request.getParameterValues("attrNames");
            String[] attrValues = request.getParameterValues("attrValues");
            List<ProductAttribute> attributes = new ArrayList<>();
            if (attrNames != null && attrValues != null) {
                for (int i = 0; i < attrNames.length; i++) {
                    if (attrNames[i] != null && !attrNames[i].trim().isEmpty()) {
                        attributes.add(new ProductAttribute(attrNames[i], attrValues[i]));
                    }
                }
            }
            p.setAttributes(attributes);

            // 5. Parse Variation Structure (Groups & Options)
            // Expecting params: groupName_0, groupOptions_0 (comma separated)
            // We iterate based on a count or just check dynamically.
            // Better constraint: Frontend sends a hidden input 'groupCount'
            String groupCountStr = request.getParameter("groupCount");
            int groupCount = (groupCountStr != null && !groupCountStr.isEmpty()) ? Integer.parseInt(groupCountStr) : 0;

            List<VariationGroup> groups = new ArrayList<>();

            for (int i = 0; i < groupCount; i++) {
                String gName = request.getParameter("groupName_" + i);
                String gOpts = request.getParameter("groupOptions_" + i); // "Red,Blue"

                if (gName != null && !gName.trim().isEmpty()) {
                    VariationGroup group = new VariationGroup();
                    group.setGroupName(gName);

                    List<VariationOption> options = new ArrayList<>();
                    if (gOpts != null) {
                        for (String optVal : gOpts.split(",")) {
                            if (!optVal.trim().isEmpty()) {
                                VariationOption opt = new VariationOption();
                                opt.setOptionValue(optVal.trim());
                                options.add(opt);
                            }
                        }
                    }
                    group.setOptions(options);
                    groups.add(group);
                }
            }
            p.setVariationGroups(groups);

            // 6. Save Product (and Groups/Options)
            ProductDAO dao = new ProductDAO();
            int productId = dao.addProduct(p);

            // 7. Handle Variations (SKUs)
            // Now that we have the product and Option IDs (which are in the 'groups'
            // objects due to pass-by-reference update in DAO),
            // we can link the specific variations.
            // Frontend should send: variation_sku[], variation_price[], variation_stock[],
            // variation_mapping_indices[]
            // mapping_indices: "0,1" -> indices of options in the group definition above.
            // i.e. "0,0" means Group 0 Option 0 + Group 1 Option 0.

            String[] varSkus = request.getParameterValues("varSku");
            String[] varPrices = request.getParameterValues("varPrice");
            String[] varStocks = request.getParameterValues("varStock");
            String[] varMappings = request.getParameterValues("varMapping");
            // varMapping example: "Red,Small" (values) OR indices. Let's use indices
            // "0:1,1:3" (groupId:optionIndex) or strictly ordered indices "0,0"
            // The safest is for the frontend to send the exact Option Values "Red,Small"
            // and we look them up in our `groups` list which now has IDs.

            if (varSkus != null) {
                for (int i = 0; i < varSkus.length; i++) {
                    ProductVariation pv = new ProductVariation();
                    pv.setSku(varSkus[i]);
                    pv.setPrice(Double.parseDouble(varPrices[i]));
                    pv.setStockQuantity(Integer.parseInt(varStocks[i]));
                    pv.setActive(true);

                    List<Integer> optionIdsToLink = new ArrayList<>();

                    // Parse mapping (e.g., "Red,Small")
                    if (varMappings != null && i < varMappings.length) {
                        String[] mappedValues = varMappings[i].split(",");
                        // Find matching Option IDs in our `groups` list
                        // This logic assumes specific order: Group 0 value, Group 1 value...
                        for (int g = 0; g < groups.size(); g++) {
                            if (g < mappedValues.length) {
                                String targetVal = mappedValues[g].trim();
                                VariationGroup grp = groups.get(g);
                                for (VariationOption opt : grp.getOptions()) {
                                    if (opt.getOptionValue().equalsIgnoreCase(targetVal)) {
                                        optionIdsToLink.add(opt.getOptionId());
                                        break;
                                    }
                                }
                            }
                        }
                    }

                    dao.addProductVariation(productId, pv, optionIdsToLink);
                }
            }

            response.sendRedirect(request.getContextPath() + "/ListProductsServlet?msg=success");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error adding product: " + e.getMessage());
            request.getRequestDispatcher("/pages/dashboards/storedash/addProduct.jsp").forward(request, response);
        }
    }

    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "";
    }
}
