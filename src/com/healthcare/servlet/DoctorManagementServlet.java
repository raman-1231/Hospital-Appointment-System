package com.healthcare.servlet;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import com.healthcare.dao.DoctorDAO;
import com.healthcare.model.Doctor;

/**
 * Servlet for doctor management (Admin only)
 * Handles CRUD operations for doctors
 */
@WebServlet("/DoctorManagementServlet")
public class DoctorManagementServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private DoctorDAO doctorDAO;

    @Override
    public void init() {

        doctorDAO = new DoctorDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        // Check admin login
        if (session == null ||
                !"admin".equals(
                        session.getAttribute("userType"))) {

            response.sendRedirect("login.jsp");
            return;
        }

        String action =
                request.getParameter("action");

        if ("add".equals(action)) {

            addDoctor(request, response);

        } else if ("update".equals(action)) {

            updateDoctor(request, response);

        } else if ("delete".equals(action)) {

            deleteDoctor(request, response);

        } else {

            response.sendRedirect("admin.jsp");
        }
    }

    // ADD DOCTOR
    private void addDoctor(HttpServletRequest request,
                           HttpServletResponse response)
            throws ServletException, IOException {

        String doctorName =
                request.getParameter("doctorName");

        String specialization =
                request.getParameter("specialization");

        String email =
                request.getParameter("email");

        String phone =
                request.getParameter("phone");

        String experienceStr =
                request.getParameter("experience");

        // Validation
        if (doctorName == null ||
                specialization == null ||
                doctorName.trim().isEmpty() ||
                specialization.trim().isEmpty()) {

            request.setAttribute(
                    "error",
                    "Doctor name and specialization are required!"
            );

            request.getRequestDispatcher(
                    "admin.jsp"
            ).forward(request, response);

            return;
        }

        try {

            int experience =
                    Integer.parseInt(
                            experienceStr != null
                                    ? experienceStr
                                    : "0"
                    );

            Doctor doctor =
                    new Doctor(
                            doctorName,
                            specialization,
                            email,
                            phone,
                            experience
                    );

            boolean isAdded =
                    doctorDAO.addDoctor(doctor);

            if (isAdded) {

                request.setAttribute(
                        "success",
                        "Doctor added successfully!"
                );

            } else {

                request.setAttribute(
                        "error",
                        "Failed to add doctor!"
                );
            }

        } catch (NumberFormatException e) {

            request.setAttribute(
                    "error",
                    "Invalid experience value!"
            );
        }

        request.getRequestDispatcher(
                "admin.jsp"
        ).forward(request, response);
    }

    // UPDATE DOCTOR
    private void updateDoctor(HttpServletRequest request,
                              HttpServletResponse response)
            throws ServletException, IOException {

        String doctorIdStr =
                request.getParameter("doctorId");

        String doctorName =
                request.getParameter("doctorName");

        String specialization =
                request.getParameter("specialization");

        String email =
                request.getParameter("email");

        String phone =
                request.getParameter("phone");

        String experienceStr =
                request.getParameter("experience");

        try {

            int doctorId =
                    Integer.parseInt(doctorIdStr);

            int experience =
                    Integer.parseInt(
                            experienceStr != null
                                    ? experienceStr
                                    : "0"
                    );

            Doctor doctor =
                    new Doctor(
                            doctorName,
                            specialization,
                            email,
                            phone,
                            experience
                    );

            doctor.setId(doctorId);

            boolean isUpdated =
                    doctorDAO.updateDoctor(doctor);

            if (isUpdated) {

                request.setAttribute(
                        "success",
                        "Doctor updated successfully!"
                );

            } else {

                request.setAttribute(
                        "error",
                        "Failed to update doctor!"
                );
            }

        } catch (NumberFormatException e) {

            request.setAttribute(
                    "error",
                    "Invalid input values!"
            );
        }

        request.getRequestDispatcher(
                "admin.jsp"
        ).forward(request, response);
    }

    // DELETE DOCTOR
    private void deleteDoctor(HttpServletRequest request,
                              HttpServletResponse response)
            throws ServletException, IOException {

        String doctorIdStr =
                request.getParameter("doctorId");

        try {

            int doctorId =
                    Integer.parseInt(doctorIdStr);

            boolean isDeleted =
                    doctorDAO.deleteDoctor(doctorId);

            if (isDeleted) {

                request.setAttribute(
                        "success",
                        "Doctor removed successfully!"
                );

            } else {

                request.setAttribute(
                        "error",
                        "Failed to remove doctor!"
                );
            }

        } catch (NumberFormatException e) {

            request.setAttribute(
                    "error",
                    "Invalid doctor ID!"
            );
        }

        request.getRequestDispatcher(
                "admin.jsp"
        ).forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        response.sendRedirect("admin.jsp");
    }
}