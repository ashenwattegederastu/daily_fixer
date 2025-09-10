<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
  <title>Driver Signup - DailyFixer</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<div class="login-wrapper">
  <div class="login-card">
    <h2>Driver Signup</h2>
    <form action="${pageContext.request.contextPath}/DriverSignupServlet" method="post" onsubmit="return validateSignup()">
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
        <input type="text" name="username">
      </div>
      <div class="input-field">
        <label>Password</label>
        <input type="password" name="password">
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
        <label>Profile Picture URL</label>
        <input type="text" name="profilepic">
      </div>
      <div class="input-field">
        <label>Driver Real Picture URL</label>
        <input type="text" name="real_pic">
      </div>
      <div class="input-field">
        <label>Service Area</label>
        <input type="text" name="service_area">
      </div>
      <div class="input-field">
        <label>License Picture URL</label>
        <input type="text" name="license_pic">
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
    let fields = ['fname','lname','username','password','email','phone','service_area'];
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
