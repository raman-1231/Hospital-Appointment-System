package com.healthcare.servlet;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import com.healthcare.dao.AvailabilityDAO;
import com.healthcare.model.DoctorAvailability;

/**
 * Servlet for managing doctor availability (Admin only)
 * Handles adding and removing doctor availability slots
 */
@WebServlet("/AvailabilityServlet")
public class AvailabilityServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private AvailabilityDAO availabilityDAO;

    @Override
    public void init() {

        availabilityDAO = new AvailabilityDAO();
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

            addAvailability(request, response);

        } else if ("delete".equals(action)) {

            deleteAvailability(request, response);

        } else {

            response.sendRedirect("admin.jsp");
        }
    }

    // ADD AVAILABILITY
    private void addAvailability(HttpServletRequest request,
                                 HttpServletResponse response)
            throws ServletException, IOException {

        String doctorIdStr =
                request.getParameter("doctorId");

        String dateStr =
                request.getParameter("availableDate");

        String timeSlot =
                request.getParameter("timeSlot");

        // Validation
        if (doctorIdStr == null ||
                dateStr == null ||
                timeSlot == null ||
                doctorIdStr.trim().isEmpty() ||
                dateStr.trim().isEmpty() ||
                timeSlot.trim().isEmpty()) {

            request.setAttribute(
                    "error",
                    "All fields are required!"
            );

            request.getRequestDispatcher(
                    "admin.jsp"
            ).forward(request, response);

            return;
        }

        try {

            int doctorId =
                    Integer.parseInt(doctorIdStr);

            Date availableDate =
                    Date.valueOf(dateStr);

            DoctorAvailability availability =
                    new DoctorAvailability(
                            doctorId,
                            availableDate,
                            timeSlot
                    );

            boolean isAdded =
                    availabilityDAO.addAvailability(
                            availability
                    );

            if (isAdded) {

                request.setAttribute(
                        "success",
                        "Availability slot added successfully!"
                );

            } else {

                request.setAttribute(
                        "error",
                        "Slot may already exist!"
                );
            }

        } catch (Exception e) {

            request.setAttribute(
                    "error",
                    "Invalid input values!"
            );
        }

        request.getRequestDispatcher(
                "admin.jsp"
        ).forward(request, response);
    }

    // DELETE AVAILABILITY
    private void deleteAvailability(HttpServletRequest request,
                                    HttpServletResponse response)
            throws ServletException, IOException {

        String availabilityIdStr =
                request.getParameter("availabilityId");

        try {

            int availabilityId =
                    Integer.parseInt(availabilityIdStr);

            boolean isDeleted =
                    availabilityDAO.deleteAvailability(
                            availabilityId
                    );

            if (isDeleted) {

                request.setAttribute(
                        "success",
                        "Availability slot removed successfully!"
                );

            } else {

                request.setAttribute(
                        "error",
                        "Slot may already be booked!"
                );
            }

        } catch (NumberFormatException e) {

            request.setAttribute(
                    "error",
                    "Invalid slot ID!"
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