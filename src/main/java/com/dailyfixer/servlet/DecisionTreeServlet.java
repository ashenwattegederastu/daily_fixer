package com.dailyfixer.servlet;

import com.dailyfixer.dao.DecisionCategoryDAO;
import com.dailyfixer.dao.DecisionTreeDAO;
import com.dailyfixer.model.*;
import jakarta.json.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.StringReader;
import java.io.StringWriter;
import java.util.List;

@WebServlet(urlPatterns = {"/api/tree/*", "/api/node/*", "/api/category/*", "/api/rating/*"})
public class DecisionTreeServlet extends HttpServlet {
    
    private final DecisionTreeDAO treeDAO = new DecisionTreeDAO();
    private final DecisionCategoryDAO categoryDAO = new DecisionCategoryDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String pathInfo = request.getServletPath();
        String subPath = request.getPathInfo();
        
        try {
            JsonObject result;
            
            if (pathInfo.startsWith("/api/category")) {
                result = handleCategoryGet(request, subPath);
            } else if (pathInfo.startsWith("/api/tree")) {
                result = handleTreeGet(request, subPath);
            } else if (pathInfo.startsWith("/api/node")) {
                result = handleNodeGet(request, subPath);
            } else if (pathInfo.startsWith("/api/rating")) {
                result = handleRatingGet(request, subPath);
            } else {
                result = createErrorResponse("Unknown endpoint");
            }
            
            writeJsonResponse(response, result);
            
        } catch (Exception e) {
            e.printStackTrace();
            writeJsonResponse(response, createErrorResponse(e.getMessage()));
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String pathInfo = request.getServletPath();
        
        try {
            String body = new String(request.getInputStream().readAllBytes());
            JsonObject jsonBody = Json.createReader(new StringReader(body)).readObject();
            JsonObject result;
            
            if (pathInfo.startsWith("/api/category")) {
                result = handleCategoryPost(request, jsonBody);
            } else if (pathInfo.startsWith("/api/tree")) {
                result = handleTreePost(request, jsonBody);
            } else if (pathInfo.startsWith("/api/node")) {
                result = handleNodePost(request, jsonBody);
            } else if (pathInfo.startsWith("/api/rating")) {
                result = handleRatingPost(request, jsonBody);
            } else {
                result = createErrorResponse("Unknown endpoint");
            }
            
            writeJsonResponse(response, result);
            
        } catch (Exception e) {
            e.printStackTrace();
            writeJsonResponse(response, createErrorResponse(e.getMessage()));
        }
    }
    
    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String pathInfo = request.getServletPath();
        
        try {
            String body = new String(request.getInputStream().readAllBytes());
            JsonObject jsonBody = Json.createReader(new StringReader(body)).readObject();
            JsonObject result;
            
            if (pathInfo.startsWith("/api/tree")) {
                result = handleTreePut(jsonBody);
            } else if (pathInfo.startsWith("/api/node")) {
                result = handleNodePut(jsonBody);
            } else {
                result = createErrorResponse("Unknown endpoint");
            }
            
            writeJsonResponse(response, result);
            
        } catch (Exception e) {
            e.printStackTrace();
            writeJsonResponse(response, createErrorResponse(e.getMessage()));
        }
    }
    
    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String pathInfo = request.getServletPath();
        String subPath = request.getPathInfo();
        
        try {
            JsonObject result;
            
            if (pathInfo.startsWith("/api/tree")) {
                result = handleTreeDelete(subPath);
            } else if (pathInfo.startsWith("/api/node")) {
                result = handleNodeDelete(subPath);
            } else {
                result = createErrorResponse("Unknown endpoint");
            }
            
            writeJsonResponse(response, result);
            
        } catch (Exception e) {
            e.printStackTrace();
            writeJsonResponse(response, createErrorResponse(e.getMessage()));
        }
    }
    
    // =============== CATEGORY HANDLERS ===============
    
    private JsonObject handleCategoryGet(HttpServletRequest request, String subPath) {
        JsonObjectBuilder builder = Json.createObjectBuilder();
        
        if (subPath != null && subPath.startsWith("/subcategories/")) {
            int categoryId = Integer.parseInt(subPath.substring("/subcategories/".length()));
            List<DecisionSubcategory> subcategories = categoryDAO.getSubcategoriesByCategoryId(categoryId);
            
            JsonArrayBuilder arrBuilder = Json.createArrayBuilder();
            for (DecisionSubcategory sub : subcategories) {
                arrBuilder.add(Json.createObjectBuilder()
                    .add("subcategoryId", sub.getSubcategoryId())
                    .add("categoryId", sub.getCategoryId())
                    .add("name", sub.getName())
                );
            }
            builder.add("success", true);
            builder.add("subcategories", arrBuilder);
        } else {
            List<DecisionCategory> categories = categoryDAO.getAllCategories();
            
            JsonArrayBuilder arrBuilder = Json.createArrayBuilder();
            for (DecisionCategory cat : categories) {
                arrBuilder.add(Json.createObjectBuilder()
                    .add("categoryId", cat.getCategoryId())
                    .add("name", cat.getName())
                );
            }
            builder.add("success", true);
            builder.add("categories", arrBuilder);
        }
        
        return builder.build();
    }
    
    private JsonObject handleCategoryPost(HttpServletRequest request, JsonObject jsonBody) {
        JsonObjectBuilder builder = Json.createObjectBuilder();
        
        String type = jsonBody.getString("type", "category");
        String name = jsonBody.getString("name", "");
        
        if (name.isEmpty()) {
            return createErrorResponse("Name is required");
        }
        
        if ("subcategory".equals(type)) {
            int categoryId = jsonBody.getInt("categoryId", -1);
            if (categoryId == -1) {
                return createErrorResponse("Category ID is required");
            }
            int id = categoryDAO.addSubcategory(categoryId, name);
            if (id > 0) {
                builder.add("success", true);
                builder.add("subcategoryId", id);
            } else {
                return createErrorResponse("Failed to add subcategory");
            }
        } else {
            int id = categoryDAO.addCategory(name);
            if (id > 0) {
                builder.add("success", true);
                builder.add("categoryId", id);
            } else {
                return createErrorResponse("Failed to add category");
            }
        }
        
        return builder.build();
    }
    
    // =============== TREE HANDLERS ===============
    
    private JsonObject handleTreeGet(HttpServletRequest request, String subPath) {
        JsonObjectBuilder builder = Json.createObjectBuilder();
        
        String subcategoryIdParam = request.getParameter("subcategoryId");
        String userIdParam = request.getParameter("userId");
        
        if (subPath != null && subPath.length() > 1) {
            // Get specific tree with hierarchical structure
            int treeId = Integer.parseInt(subPath.substring(1));
            DecisionTree tree = treeDAO.getTreeById(treeId);
            
            if (tree == null) {
                return createErrorResponse("Tree not found");
            }
            
            DecisionNode rootNode = treeDAO.getHierarchicalTree(treeId);
            
            builder.add("success", true);
            builder.add("tree", buildTreeJson(tree));
            if (rootNode != null) {
                builder.add("rootNode", buildNodeJson(rootNode));
            }
        } else if (subcategoryIdParam != null) {
            int subcategoryId = Integer.parseInt(subcategoryIdParam);
            List<DecisionTree> trees = treeDAO.getTreesBySubcategoryId(subcategoryId);
            builder.add("success", true);
            builder.add("trees", buildTreesArrayJson(trees));
        } else if (userIdParam != null) {
            int userId = Integer.parseInt(userIdParam);
            List<DecisionTree> trees = treeDAO.getTreesByUserId(userId);
            builder.add("success", true);
            builder.add("trees", buildTreesArrayJson(trees));
        } else {
            List<DecisionTree> trees = treeDAO.getAllTrees();
            builder.add("success", true);
            builder.add("trees", buildTreesArrayJson(trees));
        }
        
        return builder.build();
    }
    
    private JsonObject handleTreePost(HttpServletRequest request, JsonObject jsonBody) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            return createErrorResponse("Not authenticated");
        }
        
        User currentUser = (User) session.getAttribute("currentUser");
        
        int subcategoryId = jsonBody.getInt("subcategoryId", -1);
        String treeName = jsonBody.getString("treeName", "");
        String description = jsonBody.getString("description", "");
        
        if (subcategoryId == -1 || treeName.isEmpty()) {
            return createErrorResponse("Subcategory ID and tree name are required");
        }
        
        int treeId = treeDAO.createTree(currentUser.getUserId(), subcategoryId, treeName, description);
        
        if (treeId > 0) {
            return Json.createObjectBuilder()
                .add("success", true)
                .add("treeId", treeId)
                .build();
        } else {
            return createErrorResponse("Failed to create tree");
        }
    }
    
    private JsonObject handleTreePut(JsonObject jsonBody) {
        int treeId = jsonBody.getInt("treeId", -1);
        String treeName = jsonBody.getString("treeName", "");
        String description = jsonBody.getString("description", "");
        
        if (treeId == -1 || treeName.isEmpty()) {
            return createErrorResponse("Tree ID and name are required");
        }
        
        boolean success = treeDAO.updateTree(treeId, treeName, description);
        
        return Json.createObjectBuilder()
            .add("success", success)
            .build();
    }
    
    private JsonObject handleTreeDelete(String subPath) {
        if (subPath == null || subPath.length() <= 1) {
            return createErrorResponse("Tree ID is required");
        }
        
        int treeId = Integer.parseInt(subPath.substring(1));
        boolean success = treeDAO.deleteTree(treeId);
        
        return Json.createObjectBuilder()
            .add("success", success)
            .build();
    }
    
    // =============== NODE HANDLERS ===============
    
    private JsonObject handleNodeGet(HttpServletRequest request, String subPath) {
        JsonObjectBuilder builder = Json.createObjectBuilder();
        
        String parentIdParam = request.getParameter("parentId");
        
        if (subPath != null && subPath.length() > 1) {
            int nodeId = Integer.parseInt(subPath.substring(1));
            DecisionNode node = treeDAO.getNodeById(nodeId);
            
            if (node == null) {
                return createErrorResponse("Node not found");
            }
            
            builder.add("success", true);
            JsonObjectBuilder nodeBuilder = Json.createObjectBuilder()
                .add("nodeId", node.getNodeId())
                .add("treeId", node.getTreeId());
            if (node.getParentId() != null) {
                nodeBuilder.add("parentId", node.getParentId());
            } else {
                nodeBuilder.addNull("parentId");
            }
            nodeBuilder.add("nodeText", node.getNodeText())
                .add("optionLabel", node.getOptionLabel() != null ? node.getOptionLabel() : "")
                .add("nodeType", node.getNodeType());
            builder.add("node", nodeBuilder);
        } else if (parentIdParam != null) {
            int parentId = Integer.parseInt(parentIdParam);
            List<DecisionNode> children = treeDAO.getChildNodes(parentId);
            
            JsonArrayBuilder arrBuilder = Json.createArrayBuilder();
            for (DecisionNode node : children) {
                JsonObjectBuilder nodeBuilder = Json.createObjectBuilder()
                    .add("nodeId", node.getNodeId())
                    .add("treeId", node.getTreeId());
                if (node.getParentId() != null) {
                    nodeBuilder.add("parentId", node.getParentId());
                } else {
                    nodeBuilder.addNull("parentId");
                }
                nodeBuilder.add("nodeText", node.getNodeText())
                    .add("optionLabel", node.getOptionLabel() != null ? node.getOptionLabel() : "")
                    .add("nodeType", node.getNodeType());
                arrBuilder.add(nodeBuilder);
            }
            builder.add("success", true);
            builder.add("nodes", arrBuilder);
        } else {
            return createErrorResponse("Node ID or parent ID required");
        }
        
        return builder.build();
    }
    
    private JsonObject handleNodePost(HttpServletRequest request, JsonObject jsonBody) {
        int treeId = jsonBody.getInt("treeId", -1);
        String nodeText = jsonBody.getString("nodeText", "");
        String optionLabel = jsonBody.getString("optionLabel", "");
        String nodeType = jsonBody.getString("nodeType", "QUESTION");
        
        Integer parentId = null;
        if (jsonBody.containsKey("parentId") && !jsonBody.isNull("parentId")) {
            parentId = jsonBody.getInt("parentId");
        }
        
        if (treeId == -1 || nodeText.isEmpty()) {
            return createErrorResponse("Tree ID and node text are required");
        }
        
        int nodeId = treeDAO.addNode(treeId, parentId, nodeText, optionLabel, nodeType);
        
        if (nodeId > 0) {
            return Json.createObjectBuilder()
                .add("success", true)
                .add("nodeId", nodeId)
                .build();
        } else {
            return createErrorResponse("Failed to add node");
        }
    }
    
    private JsonObject handleNodePut(JsonObject jsonBody) {
        int nodeId = jsonBody.getInt("nodeId", -1);
        String nodeText = jsonBody.getString("nodeText", "");
        String optionLabel = jsonBody.getString("optionLabel", "");
        String nodeType = jsonBody.getString("nodeType", "QUESTION");
        
        if (nodeId == -1 || nodeText.isEmpty()) {
            return createErrorResponse("Node ID and text are required");
        }
        
        boolean success = treeDAO.updateNode(nodeId, nodeText, optionLabel, nodeType);
        
        return Json.createObjectBuilder()
            .add("success", success)
            .build();
    }
    
    private JsonObject handleNodeDelete(String subPath) {
        if (subPath == null || subPath.length() <= 1) {
            return createErrorResponse("Node ID is required");
        }
        
        int nodeId = Integer.parseInt(subPath.substring(1));
        boolean success = treeDAO.deleteNode(nodeId);
        
        return Json.createObjectBuilder()
            .add("success", success)
            .build();
    }
    
    // =============== RATING HANDLERS ===============
    
    private JsonObject handleRatingGet(HttpServletRequest request, String subPath) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            return createErrorResponse("Not authenticated");
        }
        
        User currentUser = (User) session.getAttribute("currentUser");
        
        String treeIdParam = request.getParameter("treeId");
        if (treeIdParam == null) {
            return createErrorResponse("Tree ID is required");
        }
        
        int treeId = Integer.parseInt(treeIdParam);
        int rating = treeDAO.getUserRating(treeId, currentUser.getUserId());
        
        return Json.createObjectBuilder()
            .add("success", true)
            .add("rating", rating)
            .build();
    }
    
    private JsonObject handleRatingPost(HttpServletRequest request, JsonObject jsonBody) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            return createErrorResponse("Not authenticated");
        }
        
        User currentUser = (User) session.getAttribute("currentUser");
        
        int treeId = jsonBody.getInt("treeId", -1);
        int rating = jsonBody.getInt("rating", -1);
        
        if (treeId == -1 || rating < 1 || rating > 5) {
            return createErrorResponse("Valid tree ID and rating (1-5) are required");
        }
        
        boolean success = treeDAO.addOrUpdateRating(treeId, currentUser.getUserId(), rating);
        
        // Get updated tree info
        DecisionTree tree = treeDAO.getTreeById(treeId);
        
        JsonObjectBuilder builder = Json.createObjectBuilder()
            .add("success", success);
        
        if (tree != null) {
            builder.add("avgRating", tree.getAvgRating());
            builder.add("ratingCount", tree.getRatingCount());
        }
        
        return builder.build();
    }
    
    // =============== HELPER METHODS ===============
    
    private JsonObject buildTreeJson(DecisionTree tree) {
        return Json.createObjectBuilder()
            .add("treeId", tree.getTreeId())
            .add("userId", tree.getUserId())
            .add("subcategoryId", tree.getSubcategoryId())
            .add("treeName", tree.getTreeName())
            .add("description", tree.getDescription() != null ? tree.getDescription() : "")
            .add("avgRating", tree.getAvgRating())
            .add("ratingCount", tree.getRatingCount())
            .add("creatorUsername", tree.getCreatorUsername())
            .add("categoryName", tree.getCategoryName())
            .add("subcategoryName", tree.getSubcategoryName())
            .build();
    }
    
    private JsonArray buildTreesArrayJson(List<DecisionTree> trees) {
        JsonArrayBuilder arrBuilder = Json.createArrayBuilder();
        for (DecisionTree tree : trees) {
            arrBuilder.add(buildTreeJson(tree));
        }
        return arrBuilder.build();
    }
    
    private JsonObject buildNodeJson(DecisionNode node) {
        JsonObjectBuilder builder = Json.createObjectBuilder()
            .add("nodeId", node.getNodeId())
            .add("treeId", node.getTreeId());
        if (node.getParentId() != null) {
            builder.add("parentId", node.getParentId());
        } else {
            builder.addNull("parentId");
        }
        builder.add("nodeText", node.getNodeText())
            .add("optionLabel", node.getOptionLabel() != null ? node.getOptionLabel() : "")
            .add("nodeType", node.getNodeType());
        
        JsonArrayBuilder childrenBuilder = Json.createArrayBuilder();
        for (DecisionNode child : node.getChildren()) {
            childrenBuilder.add(buildNodeJson(child));
        }
        builder.add("children", childrenBuilder);
        
        return builder.build();
    }
    
    private JsonObject createErrorResponse(String message) {
        return Json.createObjectBuilder()
            .add("success", false)
            .add("error", message)
            .build();
    }
    
    private void writeJsonResponse(HttpServletResponse response, JsonObject json) throws IOException {
        StringWriter writer = new StringWriter();
        Json.createWriter(writer).write(json);
        response.getWriter().write(writer.toString());
    }
}
