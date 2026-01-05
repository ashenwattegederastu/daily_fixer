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
import java.util.List;

@WebServlet("/EditProductServlet")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class EditProductServlet extends HttpServlet {
    private static final String UPLOAD_DIR = "assets" + File.separator + "uploads" + File.separator + "products";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Auth check
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("currentUser");
        if (user == null || !"store".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            ProductDAO dao = new ProductDAO();
            Product p = dao.getProductById(productId);

            if (p == null || !p.getStoreUsername().equals(user.getUsername())) {
                response.sendRedirect(request.getContextPath() + "/ListProductsServlet");
                return;
            }

            // Fetch variations separately for the UI
            List<ProductVariation> vars = dao.getProductVariations(productId);

            request.setAttribute("product", p);
            request.setAttribute("variations", vars);

            request.getRequestDispatcher("/pages/dashboards/storedash/editProduct.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/ListProductsServlet?error=load_failed");
        }
    }

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

            int productId = Integer.parseInt(request.getParameter("productId"));

            // 2. Parse Basic Fields
            Product p = new Product();
            p.setProductId(productId); // IMPORTANT
            p.setStoreUsername(user.getUsername());
            p.setName(request.getParameter("name"));
            p.setBrand(request.getParameter("brand"));
            p.setDescription(request.getParameter("description"));
            p.setBasePrice(Double.parseDouble(request.getParameter("basePrice")));
            p.setCategoryMain(request.getParameter("categoryMain"));
            p.setCategorySub(request.getParameter("categorySub"));
            p.setCategoryOther(request.getParameter("categoryOther"));
            p.setWarrantyInfo(request.getParameter("warrantyInfo"));
            p.setStockStatus(request.getParameter("stockStatus"));

            // 3. Handle Image Upload
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
                mainImage.setImagePath(UPLOAD_DIR.replace(File.separator, "/") + "/" + fileName);
                mainImage.setMain(true);

                List<ProductImage> imgs = new ArrayList<>();
                imgs.add(mainImage);
                p.setImages(imgs);
            }

            // 4. Parse Attributes
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
            String groupCountStr = request.getParameter("groupCount");
            int groupCount = (groupCountStr != null && !groupCountStr.isEmpty()) ? Integer.parseInt(groupCountStr) : 0;

            List<VariationGroup> groups = new ArrayList<>();

            for (int i = 0; i < groupCount; i++) {
                String gName = request.getParameter("groupName_" + i);
                String gOpts = request.getParameter("groupOptions_" + i);

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

            // 6. Update Product (replaces attrs/groups)
            ProductDAO dao = new ProductDAO();
            dao.updateProduct(p);

            // 7. Re-add Variations (SKUs)
            // Since updateProduct cleans DB variations for this ID, we treat these as new
            // inserts.
            String[] varSkus = request.getParameterValues("varSku");
            String[] varPrices = request.getParameterValues("varPrice");
            String[] varStocks = request.getParameterValues("varStock");
            String[] varMappings = request.getParameterValues("varMapping");

            if (varSkus != null) {
                for (int i = 0; i < varSkus.length; i++) {
                    ProductVariation pv = new ProductVariation();
                    pv.setSku(varSkus[i]);
                    pv.setPrice(Double.parseDouble(varPrices[i]));
                    pv.setStockQuantity(Integer.parseInt(varStocks[i]));
                    pv.setActive(true);

                    List<Integer> optionIdsToLink = new ArrayList<>();

                    if (varMappings != null && i < varMappings.length) {
                        String[] mappedValues = varMappings[i].split(",");
                        // Find matching Option IDs in our `groups` list (which now have IDs after
                        // updateProduct call, hopefully?
                        // Wait, updateProduct calls internal insertVariationGroups which updates IDs in
                        // the objects passed to it?
                        // YES, the insertVariationGroups method updates the ID in the object using
                        // setGroupId/setOptionId)

                        for (int g = 0; g < groups.size(); g++) {
                            if (g < mappedValues.length) {
                                String targetVal = mappedValues[g].trim();
                                VariationGroup grp = groups.get(g);
                                for (VariationOption opt : grp.getOptions()) {
                                    // Case insensitive match for robustness
                                    if (opt.getOptionValue().trim().equalsIgnoreCase(targetVal)) {
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

            response.sendRedirect(request.getContextPath() + "/ListProductsServlet?msg=updated");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error updating product: " + e.getMessage());
            request.getRequestDispatcher("/pages/dashboards/storedash/editProduct.jsp").forward(request, response);
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
