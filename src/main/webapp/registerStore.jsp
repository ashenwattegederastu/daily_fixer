<%@ page contentType="text/html; charset=UTF-8" %>
  <%@ page import="java.util.*" %>
    <!DOCTYPE html>
    <html>

    <head>
      <meta charset="UTF-8">
      <title>Register Store - DailyFixer</title>
      <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/framework.css">
      <style>
        body {
          display: flex;
          align-items: center;
          justify-content: center;
          min-height: 100vh;
          background-color: var(--background);
          padding: 40px 20px;
        }

        .signup-wrapper {
          display: flex;
          gap: 30px;
          max-width: 1000px;
          width: 100%;
        }

        .left-panel {
          flex: 1;
        }

        .right-panel {
          width: 320px;
          background-color: var(--card);
          color: var(--card-foreground);
          border: 1px solid var(--border);
          border-radius: var(--radius-lg);
          padding: 30px;
          box-shadow: var(--shadow-md);
          height: fit-content;
        }

        .right-panel h3 {
          color: var(--primary);
          margin-bottom: 15px;
        }

        .right-panel p {
          color: var(--muted-foreground);
          font-size: 0.9rem;
          line-height: 1.6;
          margin-bottom: 15px;
        }

        .right-panel hr {
          border: none;
          border-top: 1px solid var(--border);
          margin: 20px 0;
        }

        .right-panel a {
          color: var(--primary);
          font-weight: 600;
          text-decoration: none;
        }

        .right-panel a:hover {
          text-decoration: underline;
        }

        .section-title {
          font-size: 0.85rem;
          font-weight: 700;
          color: var(--primary);
          text-transform: uppercase;
          letter-spacing: 0.5px;
          margin-top: 24px;
          margin-bottom: 16px;
        }

        .section-title:first-of-type {
          margin-top: 0;
        }

        .form-cols {
          display: grid;
          grid-template-columns: 1fr 1fr;
          gap: 16px;
        }

        .form-container h2 {
          font-size: 2rem;
          color: var(--primary);
          margin-bottom: 10px;
        }

        .error-text {
          color: var(--destructive);
          font-size: 0.85rem;
          margin-bottom: 12px;
          font-weight: 500;
        }

        @media (max-width: 900px) {
          .signup-wrapper {
            flex-direction: column;
          }

          .right-panel {
            width: 100%;
            order: -1;
          }

          .form-cols {
            grid-template-columns: 1fr;
            gap: 0;
          }
        }
      </style>
    </head>

    <body>

      <div class="signup-wrapper">
        <div class="left-panel">
          <div class="form-container">
            <h2>Store Account</h2>

            <c:if test="${not empty errorMsg}">
              <div class="error-text">${errorMsg}</div>
            </c:if>

            <form method="post" action="registerStore" id="registerForm">
              <div class="section-title">Owner Details</div>
              <div class="form-cols">
                <div class="form-group">
                  <label for="firstName">First Name</label>
                  <input type="text" name="firstName" id="firstName" placeholder="First Name" required>
                </div>
                <div class="form-group">
                  <label for="lastName">Last Name</label>
                  <input type="text" name="lastName" id="lastName" placeholder="Last Name" required>
                </div>
              </div>

              <div class="form-cols">
                <div class="form-group">
                  <label for="username">Username</label>
                  <input type="text" name="username" id="username" placeholder="Username" required>
                </div>
                <div class="form-group">
                  <label for="password">Password</label>
                  <input type="password" name="password" id="password" placeholder="Password (min 6 chars)" required>
                </div>
              </div>

              <div class="form-group">
                <label for="email">Email</label>
                <input type="email" name="email" id="email" placeholder="Email" required>
              </div>

              <div class="form-cols">
                <div class="form-group">
                  <label for="phone">Phone Number</label>
                  <input type="text" name="phone" id="phone" placeholder="Phone Number">
                </div>
                <div class="form-group">
                  <label for="city">Your City (optional)</label>
                  <select name="city" id="city" class="filter-select" style="width: 100%;">
                    <option value="">-- Select city --</option>
                    <% String[]
                      cities={"Colombo","Kandy","Galle","Jaffna","Kurunegala","Matara","Trincomalee","Batticaloa","Negombo","Anuradhapura","Polonnaruwa","Badulla","Ratnapura","Puttalam","Kilinochchi","Mannar","Hambantota"};
                      for (String c : cities) { %>
                      <option value="<%=c%>">
                        <%=c%>
                      </option>
                      <% } %>
                  </select>
                </div>
              </div>

              <div class="section-title">Store Details</div>

              <div class="form-group">
                <label for="storeName">Store Name</label>
                <input type="text" name="storeName" id="storeName" placeholder="Store Name" required>
              </div>

              <div class="form-group">
                <label for="storeAddress">Store Address</label>
                <textarea name="storeAddress" id="storeAddress" rows="3" placeholder="Full Store Address"
                  required></textarea>
              </div>

              <div class="form-cols">
                <div class="form-group">
                  <label for="storeCity">Store City</label>
                  <select name="storeCity" id="storeCity" class="filter-select" style="width: 100%;" required>
                    <option value="">-- Select city --</option>
                    <% for (String c : cities) { %>
                      <option value="<%=c%>">
                        <%=c%>
                      </option>
                      <% } %>
                  </select>
                </div>
                <div class="form-group">
                  <label for="storeType">Store Type</label>
                  <select name="storeType" id="storeType" class="filter-select" style="width: 100%;" required>
                    <option value="">-- Select type --</option>
                    <option value="electronics">Electronics</option>
                    <option value="hardware">Hardware</option>
                    <option value="vehicle repair">Vehicle Repair</option>
                    <option value="other">Other</option>
                  </select>
                </div>
              </div>

              <button type="submit" class="btn-primary" style="width: 100%; margin-top: 24px;">Register Store</button>
            </form>
          </div>
        </div>

        <div class="right-panel">
          <h3>Why register a store?</h3>
          <p>Registering as a store lets you list products, accept repair requests, and manage orders.</p>

          <hr>

          <p>Already have an account? <a href="login.jsp">Log in</a></p>
          <p>Or go back <a href="index.jsp">Home</a></p>

          <hr>

          <p style="font-size: 0.8rem; color: var(--muted-foreground);">By registering you agree to our terms and that
            information you provide is accurate.</p>
        </div>
      </div>

      <script>
        document.getElementById('registerForm').addEventListener('submit', function (e) {
          var u = document.getElementById('username').value.trim();
          var em = document.getElementById('email').value.trim();
          var pw = document.getElementById('password').value;
          var sn = document.getElementById('storeName').value.trim();
          var sa = document.getElementById('storeAddress').value.trim();
          var sc = document.getElementById('storeCity').value;

          var err = [];
          if (!u) err.push("Username required");
          if (!em) err.push("Email required");
          if (!pw || pw.length < 6) err.push("Password required (min 6 chars)");
          if (!sn) err.push("Store name required");
          if (!sa) err.push("Store address required");
          if (!sc) err.push("Store city required");

          if (err.length) {
            alert(err.join("\\n"));
            e.preventDefault();
          }
        });
      </script>
      <script src="${pageContext.request.contextPath}/assets/js/password-toggle.js"></script>

    </body>

    </html>