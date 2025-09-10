<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="true" %>

<!DOCTYPE html>
<html>
<head>
  <title>User Signup - DailyFixer</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>

<div class="login-wrapper">
  <div class="login-card">
    <h2>User Signup</h2>
    <form action="${pageContext.request.contextPath}/SignupServlet"
          method="post"
          enctype="multipart/form-data"
          onsubmit="return validateSignup()">

      <div class="input-field">
        <label>First Name</label>
        <input type="text" name="fname">
      </div>

      <div class="input-field">
        <label>Last Name</label>
        <input type="text" name="lname">
      </div>

      <div class="input-field">
        <label>Username</label>
        <input type="text" name="username" required>
      </div>

      <div class="input-field">
        <label>Password</label>
        <input type="password" name="password" required>
      </div>

      <div class="input-field">
        <label>Email</label>
        <input type="email" name="email">
      </div>

      <div class="input-field">
        <label>Phone</label>
        <input type="text" name="phone">
      </div>

      <div class="input-field">
        <label>Profile Picture</label>
        <input type="file" name="profilepic" accept="image/*">
      </div>

      <button type="submit" class="login-btn">Sign Up</button>
    </form>

    <a href="../../pages/shared/login.jsp" class="back-link">← Back to Login</a>

    <c:if test="${not empty error}">
      <div class="error">${error}</div>
    </c:if>
  </div>
</div>

<script>
  function validateSignup() {
    let fields = ['username','password'];
    for(let f of fields){
      if(document.querySelector(`[name=${f}]`).value.trim() === ""){
        alert("Please fill all required fields");
        return false;
      }
    }
    return true;
  }
</script>
</body>
</html>
