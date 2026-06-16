package com.healthcare.servlet;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import com.healthcare.dao.AppointmentDAO;
import com.healthcare.dao.AvailabilityDAO;
import com.healthcare.model.Appointment;

/**
 * Servlet for booking appointments
 * Handles appointment booking form submission
 */
@WebServlet("/BookAppointmentServlet")
public class BookAppointmentServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private AppointmentDAO appointmentDAO;
    private AvailabilityDAO availabilityDAO;

    @Override
    public void init() {

        appointmentDAO = new AppointmentDAO();
        availabilityDAO = new AvailabilityDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Check login
        if (session == null || session.getAttribute("userId") == null) {

            response.sendRedirect("login.jsp");
            return;
        }

        // Get form data
        int userId = (Integer) session.getAttribute("userId");

        String doctorIdStr =
                request.getParameter("doctorId");

        String dateStr =
                request.getParameter("appointmentDate");

        String timeSlot =
                request.getParameter("timeSlot");

        String reason =
                request.getParameter("reason");

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
                    "bookAppointment.jsp"
            ).forward(request, response);

            return;
        }

        try {

            int doctorId =
                    Integer.parseInt(doctorIdStr);

            Date appointmentDate =
                    Date.valueOf(dateStr);

            // Check slot availability
            boolean isAvailable =
                    availabilityDAO.isSlotAvailable(
                            doctorId,
                            appointmentDate,
                            timeSlot
                    );

            if (!isAvailable) {

                request.setAttribute(
                        "error",
                        "Selected slot is not available!"
                );

                request.getRequestDispatcher(
                        "bookAppointment.jsp"
                ).forward(request, response);

                return;
            }

            // Create appointment object
            Appointment appointment =
                    new Appointment(
                            userId,
                            doctorId,
                            appointmentDate,
                            timeSlot,
                            reason
                    );

            // Save appointment
            boolean isBooked =
                    appointmentDAO.bookAppointment(
                            appointment
                    );

            if (isBooked) {

                request.setAttribute(
                        "success",
                        "Appointment booked successfully!"
                );

                request.getRequestDispatcher(
                        "viewAppointments.jsp"
                ).forward(request, response);

            } else {

                request.setAttribute(
                        "error",
                        "Failed to book appointment!"
                );

                request.getRequestDispatcher(
                        "bookAppointment.jsp"
                ).forward(request, response);
            }

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "error",
                    "Something went wrong!"
            );

            request.getRequestDispatcher(
                    "bookAppointment.jsp"
            ).forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        response.sendRedirect("bookAppointment.jsp");
    }
}