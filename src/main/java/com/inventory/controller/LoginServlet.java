package com.inventory.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

import com.inventory.dao.UserDAO;
import com.inventory.model.User;


@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet{
	
	
	protected void doPost(HttpServletRequest req, HttpServletResponse res)
			throws ServletException, IOException{
		User user = new User();
		user.setUsername((String)req.getParameter("username"));
		user.setPassword((String)req.getParameter("password"));
		
		UserDAO userdao = new UserDAO();
		User loggedin = userdao.login(user);
		

		if( loggedin != null)
		{
			String role = loggedin.getRole();
			HttpSession session = req.getSession();
			session.setAttribute("activeUser", loggedin);
			if(role.equals("ADMIN"))
			{
				res.sendRedirect("AdminDashboardServlet");
			}else if(role.equals("MANAGER")) {
				res.sendRedirect("ManagerDashboardServlet");
			}else {
				res.sendRedirect("Login.jsp");
			}
		}else {
			res.sendRedirect("Login.jsp");
		}
	}
}
