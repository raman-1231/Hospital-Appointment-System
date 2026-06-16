package com.healthcare.servlet;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import com.healthcare.dao.UserDAO;
import com.healthcare.dao.AppointmentDAO;

/**
 * Servlet for general admin management tasks (patients, appointments)
 */
@WebServlet("/AdminManagementServlet")
public class AdminManagementServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;
    private AppointmentDAO appointmentDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
        appointmentDAO = new AppointmentDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Check if admin is logged in
        if (session == null || !"admin".equals(session.getAttribute("userType"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");

        if ("deletePatient".equals(action)) {
            deletePatient(request, response);
        } else if ("cancelAppointment".equals(action)) {
            cancelAppointment(request, response);
        } else if ("completeAppointment".equals(action)) {
            completeAppointment(request, response);
        } else {
            response.sendRedirect("admin.jsp");
        }
    }

    private void deletePatient(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String patientIdStr = request.getParameter("patientId");
        try {
            int patientId = Integer.parseInt(patientIdStr);
            boolean isDeleted = userDAO.deleteUser(patientId);

            if (isDeleted) {
                request.setAttribute("success", "Patient deleted successfully!");
            } else {
                request.setAttribute("error", "Failed to delete patient!");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid patient ID!");
        }

        request.getRequestDispatcher("admin.jsp").forward(request, response);
    }

    private void cancelAppointment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String appointmentIdStr = request.getParameter("appointmentId");
        try {
            int appointmentId = Integer.parseInt(appointmentIdStr);
            boolean isCancelled = appointmentDAO.cancelAppointmentAndReleaseSlot(appointmentId);

            if (isCancelled) {
                request.setAttribute("success", "Appointment cancelled and slot released successfully!");
            } else {
                request.setAttribute("error", "Failed to cancel appointment!");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid appointment ID!");
        }

        request.getRequestDispatcher("admin.jsp").forward(request, response);
    }

    private void completeAppointment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String appointmentIdStr = request.getParameter("appointmentId");
        try {
            int appointmentId = Integer.parseInt(appointmentIdStr);
            boolean isCompleted = appointmentDAO.updateAppointmentStatus(appointmentId, "completed");

            if (isCompleted) {
                request.setAttribute("success", "Appointment marked as completed successfully!");
            } else {
                request.setAttribute("error", "Failed to complete appointment!");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid appointment ID!");
        }

        request.getRequestDispatcher("admin.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("admin.jsp");
    }
}
