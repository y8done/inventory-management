<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="com.inventory.model.User" %>
<%
	User currentUser = (User)session.getAttribute("activeUser");
	if(currentUser == null || !currentUser.getRole().equals("ADMIN"))
	{
		response.sendRedirect("Login.jsp");
		return;
	}
%>
 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	
</body>
</html>