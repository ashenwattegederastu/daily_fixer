<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.dailyfixer.model.Guide" %>
<%@ page import="com.dailyfixer.model.GuideStep" %>
<%@ page import="com.dailyfixer.model.GuideComment" %>
<%@ page import="com.dailyfixer.model.User" %>
<%@ page import="com.dailyfixer.dao.GuideDAO" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    Guide guide = (Guide) request.getAttribute("guide");
    List<GuideComment> comments = (List<GuideComment>) request.getAttribute("comments");
    String userRating = (String) request.getAttribute("userRating");
    User currentUser = (User) session.getAttribute("currentUser");
    GuideDAO dao = new GuideDAO();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= guide != null ? guide.getTitle() : "Guide" %> | Daily Fixer</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/framework.css">
    <style>
        .guide-container {
            max-width: 900px;
            margin: 100px auto 3rem;
            padding: 1rem 2rem;
        }
        .guide-header {
            background: var(--card);
            border-radius: var(--radius-lg);
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--border);
        }
        .guide-header img {
            width: 100%;
            max-height: 400px;
            object-fit: cover;
            border-radius: var(--radius-md);
            margin-bottom: 1.5rem;
        }
        .guide-title {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 1rem;
            color: var(--primary);
        }
        .guide-meta {
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
            margin-bottom: 1rem;
            align-items: center;
        }
        .category-tag {
            padding: 0.4rem 0.8rem;
            background: var(--accent);
            color: var(--accent-foreground);
            border-radius: var(--radius-sm);
            font-size: 0.85rem;
            font-weight: 500;
        }
        .creator-info {
            color: var(--muted-foreground);
            font-size: 0.9rem;
        }
        .rating-section {
            display: flex;
            gap: 1rem;
            align-items: center;
            margin-top: 1.5rem;
            padding-top: 1.5rem;
            border-top: 1px solid var(--border);
        }
        .rating-btn {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.5rem 1rem;
            border: 2px solid var(--border);
            border-radius: var(--radius-md);
            background: var(--card);
            cursor: pointer;
            font-size: 1rem;
            transition: all 0.2s;
        }
        .rating-btn:hover {
            border-color: var(--primary);
        }
        .rating-btn.active-up {
            background: oklch(0.6290 0.1902 156.4499);
            color: white;
            border-color: oklch(0.6290 0.1902 156.4499);
        }
        .rating-btn.active-down {
            background: var(--destructive);
            color: white;
            border-color: var(--destructive);
        }
        .rating-count {
            font-weight: 600;
        }
        .requirements-section {
            background: var(--card);
            border-radius: var(--radius-lg);
            padding: 1.5rem;
            margin-bottom: 2rem;
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--border);
            border-left: 4px solid var(--primary);
        }
        .requirements-section h2 {
            font-size: 1.3rem;
            margin-bottom: 1rem;
            color: var(--foreground);
        }
        .requirements-section ul {
            padding-left: 1.5rem;
            color: var(--muted-foreground);
        }
        .requirements-section li {
            margin-bottom: 0.5rem;
        }
        .youtube-section {
            background: var(--card);
            border-radius: var(--radius-lg);
            padding: 1.5rem;
            margin-bottom: 2rem;
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--border);
        }
        .youtube-section h2 {
            font-size: 1.3rem;
            margin-bottom: 1rem;
            color: var(--foreground);
        }
        .youtube-embed {
            position: relative;
            padding-bottom: 56.25%;
            height: 0;
            overflow: hidden;
            border-radius: var(--radius-md);
        }
        .youtube-embed iframe {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            border: none;
        }
        .steps-section {
            background: var(--card);
            border-radius: var(--radius-lg);
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--border);
        }
        .steps-section h2 {
            font-size: 1.5rem;
            margin-bottom: 1.5rem;
            color: var(--foreground);
        }
        .step {
            display: flex;
            gap: 1.5rem;
            margin-bottom: 2rem;
            padding-bottom: 2rem;
            border-bottom: 1px solid var(--border);
        }
        .step:last-child {
            border-bottom: none;
            margin-bottom: 0;
            padding-bottom: 0;
        }
        .step-number {
            flex-shrink: 0;
            width: 40px;
            height: 40px;
            background: var(--primary);
            color: var(--primary-foreground);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
        }
        .step-content {
            flex: 1;
        }
        .step-content h3 {
            font-size: 1.2rem;
            margin-bottom: 0.75rem;
            color: var(--foreground);
        }
        .step-content p {
            color: var(--muted-foreground);
            line-height: 1.6;
            white-space: pre-wrap;
        }
        .step-images {
            display: flex;
            gap: 0.5rem;
            flex-wrap: wrap;
            margin-top: 1rem;
        }
        .step-images img {
            max-width: 300px;
            border-radius: var(--radius-md);
            box-shadow: var(--shadow-sm);
        }
        .comments-section {
            background: var(--card);
            border-radius: var(--radius-lg);
            padding: 2rem;
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--border);
        }
        .comments-section h2 {
            font-size: 1.5rem;
            margin-bottom: 1.5rem;
            color: var(--foreground);
        }
        .comment-form {
            margin-bottom: 2rem;
        }
        .comment-form textarea {
            width: 100%;
            padding: 1rem;
            border: 2px solid var(--border);
            border-radius: var(--radius-md);
            font-family: inherit;
            font-size: 0.95rem;
            background: var(--input);
            color: var(--foreground);
            resize: vertical;
            min-height: 100px;
            margin-bottom: 1rem;
        }
        .comment-form textarea:focus {
            outline: none;
            border-color: var(--primary);
        }
        .comment-form button {
            padding: 0.75rem 1.5rem;
            background: var(--primary);
            color: var(--primary-foreground);
            border: none;
            border-radius: var(--radius-md);
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        .comment-form button:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }
        .comment-item {
            padding: 1rem;
            background: var(--muted);
            border-radius: var(--radius-md);
            margin-bottom: 1rem;
        }
        .comment-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 0.5rem;
        }
        .comment-author {
            font-weight: 600;
            color: var(--foreground);
        }
        .comment-date {
            font-size: 0.8rem;
            color: var(--muted-foreground);
        }
        .comment-text {
            color: var(--foreground);
            line-height: 1.5;
        }
        .delete-comment-btn {
            background: var(--destructive);
            color: var(--destructive-foreground);
            border: none;
            padding: 0.25rem 0.5rem;
            border-radius: var(--radius-sm);
            cursor: pointer;
            font-size: 0.75rem;
        }
        .back-btn {
            display: inline-block;
            margin-bottom: 1.5rem;
            padding: 0.75rem 1.5rem;
            background: var(--secondary);
            color: var(--secondary-foreground);
            text-decoration: none;
            border-radius: var(--radius-md);
            font-weight: 600;
            transition: all 0.3s ease;
            border: 1px solid var(--border);
        }
        .back-btn:hover {
            background: var(--accent);
        }
        .login-prompt {
            padding: 1rem;
            background: var(--muted);
            border-radius: var(--radius-md);
            text-align: center;
            color: var(--muted-foreground);
        }
        .login-prompt a {
            color: var(--primary);
            font-weight: 600;
        }
    </style>
</head>
<body>
<jsp:include page="/pages/shared/header.jsp" />

<div class="guide-container">
    <a href="${pageContext.request.contextPath}/ViewGuidesServlet" class="back-btn">← Back to Guides</a>
    
    <% if (guide != null) { %>
    
    <!-- Guide Header -->
    <div class="guide-header">
        <% if (guide.getMainImage() != null) { %>
        <img src="${pageContext.request.contextPath}/ImageServlet?id=<%= guide.getGuideId() %>" alt="<%= guide.getTitle() %>">
        <% } %>
        <h1 class="guide-title"><%= guide.getTitle() %></h1>
        <div class="guide-meta">
            <span class="category-tag"><%= guide.getMainCategory() %></span>
            <span class="category-tag"><%= guide.getSubCategory() %></span>
            <span class="creator-info">By <%= guide.getCreatorName() != null ? guide.getCreatorName() : "Unknown" %></span>
        </div>
        
        <!-- Rating Section -->
        <div class="rating-section">
            <% if (currentUser != null) { %>
            <form action="${pageContext.request.contextPath}/RateGuideServlet" method="post" style="display: inline;">
                <input type="hidden" name="guideId" value="<%= guide.getGuideId() %>">
                <input type="hidden" name="rating" value="UP">
                <button type="submit" class="rating-btn <%= "UP".equals(userRating) ? "active-up" : "" %>">
                    👍 <span class="rating-count"><%= guide.getUpVotes() %></span>
                </button>
            </form>
            <form action="${pageContext.request.contextPath}/RateGuideServlet" method="post" style="display: inline;">
                <input type="hidden" name="guideId" value="<%= guide.getGuideId() %>">
                <input type="hidden" name="rating" value="DOWN">
                <button type="submit" class="rating-btn <%= "DOWN".equals(userRating) ? "active-down" : "" %>">
                    👎 <span class="rating-count"><%= guide.getDownVotes() %></span>
                </button>
            </form>
            <% } else { %>
            <span class="rating-btn">👍 <span class="rating-count"><%= guide.getUpVotes() %></span></span>
            <span class="rating-btn">👎 <span class="rating-count"><%= guide.getDownVotes() %></span></span>
            <span style="color: var(--muted-foreground); font-size: 0.9rem;">
                <a href="${pageContext.request.contextPath}/login.jsp">Login</a> to rate
            </span>
            <% } %>
        </div>
    </div>
    
    <!-- Requirements Section -->
    <% if (guide.getRequirements() != null && !guide.getRequirements().isEmpty()) { %>
    <div class="requirements-section">
        <h2>Things You Need</h2>
        <ul>
            <% for (String req : guide.getRequirements()) { %>
            <li><%= req %></li>
            <% } %>
        </ul>
    </div>
    <% } %>
    
    <!-- YouTube Section -->
    <% if (guide.getYoutubeUrl() != null && !guide.getYoutubeUrl().trim().isEmpty()) { 
        String youtubeUrl = guide.getYoutubeUrl();
        String videoId = "";
        if (youtubeUrl.contains("v=")) {
            videoId = youtubeUrl.substring(youtubeUrl.indexOf("v=") + 2);
            if (videoId.contains("&")) {
                videoId = videoId.substring(0, videoId.indexOf("&"));
            }
        } else if (youtubeUrl.contains("youtu.be/")) {
            videoId = youtubeUrl.substring(youtubeUrl.indexOf("youtu.be/") + 9);
            if (videoId.contains("?")) {
                videoId = videoId.substring(0, videoId.indexOf("?"));
            }
        }
        // Validate video ID format (only allow alphanumeric, underscore, and hyphen)
        if (!videoId.isEmpty() && videoId.matches("^[a-zA-Z0-9_-]{11}$")) {
    %>
    <div class="youtube-section">
        <h2>Video Tutorial</h2>
        <div class="youtube-embed">
            <iframe src="https://www.youtube.com/embed/<%= videoId %>" 
                    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" 
                    allowfullscreen></iframe>
        </div>
    </div>
    <% } } %>
    
    <!-- Steps Section -->
    <% if (guide.getSteps() != null && !guide.getSteps().isEmpty()) { %>
    <div class="steps-section">
        <h2>Guide Steps</h2>
        <% for (GuideStep step : guide.getSteps()) { %>
        <div class="step">
            <div class="step-number"><%= step.getStepOrder() %></div>
            <div class="step-content">
                <h3><%= step.getStepTitle() %></h3>
                <p><%= step.getStepBody() != null ? step.getStepBody() : "" %></p>
                <% 
                    List<Integer> imageIds = dao.getStepImageIds(step.getStepId());
                    if (imageIds != null && !imageIds.isEmpty()) { 
                %>
                <div class="step-images">
                    <% for (Integer imgId : imageIds) { %>
                    <img src="${pageContext.request.contextPath}/StepImageServlet?id=<%= imgId %>" alt="Step Image">
                    <% } %>
                </div>
                <% } %>
            </div>
        </div>
        <% } %>
    </div>
    <% } %>
    
    <!-- Comments Section -->
    <div class="comments-section">
        <h2>Comments</h2>
        
        <% if (currentUser != null) { %>
        <form action="${pageContext.request.contextPath}/AddCommentServlet" method="post" class="comment-form">
            <input type="hidden" name="guideId" value="<%= guide.getGuideId() %>">
            <textarea name="comment" placeholder="Write a comment..." required></textarea>
            <button type="submit">Post Comment</button>
        </form>
        <% } else { %>
        <div class="login-prompt">
            <a href="${pageContext.request.contextPath}/login.jsp">Login</a> to leave a comment
        </div>
        <% } %>
        
        <% if (comments != null && !comments.isEmpty()) { %>
            <% for (GuideComment comment : comments) { %>
            <div class="comment-item">
                <div class="comment-header">
                    <span class="comment-author"><%= comment.getUserName() %></span>
                    <div>
                        <span class="comment-date"><%= comment.getCreatedAt() %></span>
                        <% if (currentUser != null && currentUser.getUserId() == comment.getUserId()) { %>
                        <form action="${pageContext.request.contextPath}/DeleteCommentServlet" method="post" style="display: inline;">
                            <input type="hidden" name="commentId" value="<%= comment.getCommentId() %>">
                            <input type="hidden" name="guideId" value="<%= guide.getGuideId() %>">
                            <button type="submit" class="delete-comment-btn" onclick="return confirm('Delete this comment?')">Delete</button>
                        </form>
                        <% } %>
                    </div>
                </div>
                <p class="comment-text"><%= comment.getComment() %></p>
            </div>
            <% } %>
        <% } else { %>
        <p style="color: var(--muted-foreground); text-align: center; padding: 2rem;">No comments yet. Be the first to comment!</p>
        <% } %>
    </div>
    
    <% } else { %>
    <div class="empty-state">
        <h3>Guide not found</h3>
        <p>The guide you're looking for doesn't exist or has been removed.</p>
    </div>
    <% } %>
</div>

<script src="${pageContext.request.contextPath}/assets/js/dark-mode.js"></script>
</body>
</html>
