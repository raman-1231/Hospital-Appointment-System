package com.healthcare.servlet;

import com.healthcare.dao.UserDAO;
import com.healthcare.model.User;
import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        // Get form data
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");

        // Validation
        if (name == null || email == null || password == null ||
                name.trim().isEmpty() ||
                email.trim().isEmpty() ||
                password.trim().isEmpty()) {

            response.sendRedirect("register.jsp");
            return;
        }

        // Create user object
        User user = new User(name, email, password, phone);

        // Save user
        boolean status = userDAO.registerUser(user);

        if (status) {

            // Registration success
            response.sendRedirect("login.jsp");

        } else {

            // Registration failed
            response.sendRedirect("register.jsp");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        response.sendRedirect("register.jsp");
    }
}