package com.healthcare.servlet;

import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import com.healthcare.dao.UserDAO;
import com.healthcare.dao.AdminDAO;
import com.healthcare.model.User;
/**
 * Servlet for User and Admin Login
 * Handles authentication and session management
 */

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private UserDAO userDAO;
    private AdminDAO adminDAO;

    /**
     * Initialize DAO objects
     */
    @Override
    public void init() {

        userDAO = new UserDAO();
        adminDAO = new AdminDAO();
    }

    /**
     * Handle POST request for login
     */
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        // Get form data
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String userType = request.getParameter("userType");

        // Validation
        if (email == null || password == null ||
                email.trim().isEmpty() ||
                password.trim().isEmpty()) {

            request.setAttribute(
                    "error",
                    "Email and Password are required!"
            );

            request.getRequestDispatcher("login.jsp")
                    .forward(request, response);

            return;
        }

        // Create Session
        HttpSession session = request.getSession();

        /**
         * ADMIN LOGIN
         */
        if ("admin".equals(userType)) {

            boolean isValidAdmin =
                    adminDAO.validateAdmin(email, password);

            if (isValidAdmin) {

                String adminName =
                        adminDAO.getAdminName(email);

                // Store session data
                session.setAttribute("userType", "admin");
                session.setAttribute("userName", adminName);
                session.setAttribute("userEmail", email);

                // Redirect to admin dashboard
                response.sendRedirect("admin.jsp");

            } else {

                request.setAttribute(
                        "error",
                        "Invalid Admin Credentials!"
                );

                request.getRequestDispatcher("login.jsp")
                        .forward(request, response);
            }

        } else {

            /**
             * PATIENT LOGIN
             */

            User user =
                    userDAO.validateUser(email, password);

            if (user != null) {

                // Store session data
                session.setAttribute("userType", "patient");
                session.setAttribute("userId", user.getId());
                session.setAttribute("userName", user.getName());
                session.setAttribute("userEmail", user.getEmail());

                // Redirect to patient dashboard
                response.sendRedirect("dashboard.jsp");

            } else {

                request.setAttribute(
                        "error",
                        "Invalid Email or Password!"
                );

                request.getRequestDispatcher("login.jsp")
                        .forward(request, response);
            }
        }
    }

    /**
     * Handle GET request
     */
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        response.sendRedirect("login.jsp");
    }
}