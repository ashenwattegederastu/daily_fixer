<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Register Store - DailyFixer</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
  <style>
    .signup-wrapper { display:flex; justify-content:center; padding:100px 20px; }
    .card { width:900px; max-width: 1000px; display:flex; gap:30px; }
    .left, .right { background:#fff; padding:30px; border-radius:12px; box-shadow: 0 8px 20px rgba(0,0,0,0.08); }
    .left { flex:1; }
    .right { width:420px; }
    .section-title { font-size:18px; margin-bottom:12px; font-weight:600; }
    .input-row { display:flex; gap:12px; }
    .input-row > div { flex:1; }
    .small { width:100%; box-sizing:border-box; padding:10px; border-radius:8px; border:1px solid #ccc; }
    .error { color:#b00020; margin-bottom:12px; }
  </style>
</head>
<body>

<div class="signup-wrapper">
  <div class="card">
    <div class="left">
      <h2>Store Account</h2>

      <c:if test="${not empty errorMsg}">
        <div class="error">${errorMsg}</div>
      </c:if>

      <form method="post" action="registerStore" onsubmit="return validateForm();">
        <!-- User fields -->
        <div class="section-title">Owner details</div>
        <div class="input-row">
          <div>
            <label>First name</label>
            <input class="small" type="text" name="firstName" id="firstName" required>
          </div>
          <div>
            <label>Last name</label>
            <input class="small" type="text" name="lastName" id="lastName" required>
          </div>
        </div>

        <div class="input-row" style="margin-top:12px;">
          <div>
            <label>Username</label>
            <input class="small" type="text" name="username" id="username" required>
          </div>
          <div>
            <label>Password</label>
            <input class="small" type="password" name="password" id="password" required>
          </div>
        </div>

        <div style="margin-top:12px;">
          <label>Email</label>
          <input class="small" type="email" name="email" id="email" required>
        </div>

        <div style="margin-top:12px;">
          <label>Phone number</label>
          <input class="small" type="text" name="phone" id="phone">
        </div>

        <div style="margin-top:12px;">
          <label>Your City (optional)</label>
          <select class="small" name="city">
            <option value="">-- Select city --</option>
            <%
              String[] cities = {"Colombo","Kandy","Galle","Jaffna","Kurunegala","Matara","Trincomalee","Batticaloa","Negombo","Anuradhapura","Polonnaruwa","Badulla","Ratnapura","Puttalam","Kilinochchi","Mannar","Hambantota"};
              for (String c : cities) {
            %>
            <option value="<%=c%>"><%=c%></option>
            <% } %>
          </select>
        </div>

        <!-- Store fields -->
        <div class="section-title" style="margin-top:18px;">Store details</div>

        <div style="margin-top:6px;">
          <label>Store name</label>
          <input class="small" type="text" name="storeName" id="storeName" required>
        </div>

        <div style="margin-top:12px;">
          <label>Store address</label>
          <textarea class="small" name="storeAddress" id="storeAddress" rows="3" required></textarea>
        </div>

        <div class="input-row" style="margin-top:12px;">
          <div>
            <label>Store city</label>
            <select class="small" name="storeCity" id="storeCity" required>
              <option value="">-- Select city --</option>
              <%
                for (String c : cities) {
              %>
              <option value="<%=c%>"><%=c%></option>
              <% } %>
            </select>
          </div>
          <div>
            <label>Store type</label>
            <select class="small" name="storeType" id="storeType" required>
              <option value="">-- Select type --</option>
              <option value="electronics">Electronics</option>
              <option value="hardware">Hardware</option>
              <option value="vehicle repair">Vehicle Repair</option>
              <option value="other">Other</option>
            </select>
          </div>
        </div>

        <div style="margin-top:18px;">
          <button type="submit" class="login-btn">Register Store</button>
        </div>
      </form>
    </div>

    <div class="right">
      <h3>Why register a store?</h3>
      <p>Registering as a store lets you list products, accept repair requests, and manage orders.</p>

      <hr>

      <p>Already have an account? <a href="login.jsp">Log in</a></p>
      <p>Or go back <a href="index.jsp">Home</a></p>

      <hr>

      <p style="font-size:13px;color:#666;">By registering you agree to our terms and that information you provide is accurate.</p>
    </div>
  </div>
</div>

<script>
  function validateForm(){
    // client side checks
    var u = document.getElementById('username').value.trim();
    var em = document.getElementById('email').value.trim();
    var pw = document.getElementById('password').value;
    var sn = document.getElementById('storeName').value.trim();
    var sa = document.getElementById('storeAddress').value.trim();
    var sc = document.getElementById('storeCity').value;

    var err = [];
    if(!u) err.push("Username required");
    if(!em) err.push("Email required");
    if(!pw || pw.length < 6) err.push("Password required (min 6 chars)");
    if(!sn) err.push("Store name required");
    if(!sa) err.push("Store address required");
    if(!sc) err.push("Store city required");

    if(err.length){
      alert(err.join("\\n"));
      return false;
    }
    return true;
  }
</script>
<script src="${pageContext.request.contextPath}/assets/js/password-toggle.js"></script>

</body>
</html>
