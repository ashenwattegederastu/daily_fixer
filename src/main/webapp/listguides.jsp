<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Redirect to the dynamic guides servlet
    response.sendRedirect(request.getContextPath() + "/ViewGuidesServlet");
%>