<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Repair Guides | Daily Fixer</title>

    <style>
        /* ===== Page-Specific Styles ===== */
        .page-container {
            max-width: 1100px;
            margin: 100px auto 3rem;
            padding: 1rem;
        }

        .page-title {
            font-size: 2rem;
            text-align: center;
            margin-bottom: 2rem;
            background: linear-gradient(135deg, var(--primary-purple), var(--primary-blue));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .search-bar {
            display: flex;
            justify-content: center;
            margin-bottom: 2rem;
        }

        .search-bar input {
            width: 60%;
            padding: 0.8rem 1rem;
            border: 1px solid rgba(139,125,216,0.3);
            border-radius: 8px;
            outline: none;
            font-size: 1rem;
        }

        .guides-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
            gap: 2rem;
        }

        .guide-card {
            background: var(--white);
            border-radius: 12px;
            box-shadow: var(--shadow-sm);
            overflow: hidden;
            transition: all 0.3s ease;
            border: 1px solid rgba(139, 125, 216, 0.1);
        }

        .guide-card:hover {
            transform: translateY(-6px);
            box-shadow: var(--shadow-lg);
        }

        .guide-card img {
            width: 100%;
            height: 180px;
            object-fit: cover;
        }

        .guide-content {
            padding: 1rem 1.2rem;
        }

        .guide-content h3 {
            margin-bottom: 0.5rem;
        }

        .guide-content p {
            color: var(--text-light);
            font-size: 0.9rem;
            margin-bottom: 1rem;
        }

        .view-btn {
            display: inline-block;
            padding: 0.5rem 1.2rem;
            background: linear-gradient(135deg, var(--primary-purple), var(--primary-blue));
            color: var(--white);
            text-decoration: none;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .view-btn:hover {
            box-shadow: var(--shadow-md);
            transform: translateY(-2px);
        }
    </style>
</head>
<body>

<!-- Include Header -->
<jsp:include page="/pages/shared/header.jsp" />

<!-- Page Content -->
<div class="page-container">
    <h1 class="page-title">Repair Guides</h1>

    <div class="search-bar">
        <input type="text" placeholder="How to repair AC">
    </div>

    <div class="guides-grid">
        <div class="guide-card">
            <img src="${pageContext.request.contextPath}/assets/images/pictures/Wasserhahn.jpg" alt="Fix a Tap">
            <div class="guide-content">
                <h3>Fix a Tap</h3>
                <p>Learn how to fix a leaking tap in a few easy steps.</p>
                <a href="${pageContext.request.contextPath}/viewguide.jsp" class="view-btn">View Guide</a>
            </div>
        </div>

        <div class="guide-card">
            <img src="${pageContext.request.contextPath}/assets/images/pictures/GettyImages-1265030789-06c953db12a64560822154baa4166c08.jpg" alt="Repair a Chair">
            <div class="guide-content">
                <h3>Repair a Chair</h3>
                <p>Step-by-step guide to fix a wobbly or broken chair.</p>
                <a href="#" class="view-btn">View Guide</a>
            </div>
        </div>

        <div class="guide-card">
            <img src="${pageContext.request.contextPath}/assets/images/pictures/images.jpeg" alt="Replace a Cars Oil Filter">
            <div class="guide-content">
                <h3>Replace the Oil Filter of your car</h3>
                <p>Shows you how to replace the oil filter of your car by yourself</p>
                <a href="#" class="view-btn">View Guide</a>
            </div>
        </div>
    </div>
</div>

</body>
</html>