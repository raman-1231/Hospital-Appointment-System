package com.healthcare.servlet;

import java.io.IOException;
import java.sql.Date;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.google.gson.Gson;
import com.healthcare.dao.AvailabilityDAO;
import com.healthcare.model.DoctorAvailability;

/**
 * Servlet to fetch available slots for a doctor on a selected date
 * Returns JSON response for AJAX calls
 */
@WebServlet({"/GetAvailableSlotsServlet", "/GetAvailableSlots"})
public class GetAvailableSlotsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private AvailabilityDAO availabilityDAO;

    @Override
    public void init() {
        availabilityDAO = new AvailabilityDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Set response type
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // Get parameters
        String doctorIdStr = request.getParameter("doctorId");
        String dateStr = request.getParameter("date");
        Gson gson = new Gson();

        try {
            // Validation
            if (doctorIdStr == null || dateStr == null ||
                    doctorIdStr.trim().isEmpty() || dateStr.trim().isEmpty()) {
                response.getWriter().write("[]");
                return;
            }

            // Convert data
            int doctorId = Integer.parseInt(doctorIdStr);
            Date appointmentDate = Date.valueOf(dateStr);

            // Fetch slots
            List<DoctorAvailability> availableSlots = availabilityDAO.getAvailableSlots(doctorId, appointmentDate);

            // Convert list to JSON
            String jsonResponse = gson.toJson(availableSlots);

            // Send response
            response.getWriter().write(jsonResponse);

        } catch (Exception e) {
            e.printStackTrace();
            // Return empty JSON array
            response.getWriter().write("[]");
        }
    }
}
