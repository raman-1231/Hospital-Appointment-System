package com.healthcare.servlet;

import java.io.IOException;
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
 * Servlet to fetch all availability slots for a specific doctor
 * Returns JSON response for AJAX requests
 */
@WebServlet({"/GetDoctorAvailabilityServlet", "/GetDoctorAvailability"})
public class GetDoctorAvailabilityServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private AvailabilityDAO availabilityDAO;

    @Override
    public void init() {
        availabilityDAO = new AvailabilityDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Set JSON response
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // Get parameter
        String doctorIdStr = request.getParameter("doctorId");
        Gson gson = new Gson();

        try {
            // Validation
            if (doctorIdStr == null || doctorIdStr.trim().isEmpty()) {
                response.getWriter().write("[]");
                return;
            }

            // Convert String to Integer
            int doctorId = Integer.parseInt(doctorIdStr);

            // Fetch availability slots
            List<DoctorAvailability> availabilityList = availabilityDAO.getDoctorAvailability(doctorId);

            // Convert Java List to JSON
            String jsonResponse = gson.toJson(availabilityList);

            // Send response
            response.getWriter().write(jsonResponse);

        } catch (Exception e) {
            e.printStackTrace();
            // Return empty JSON array
            response.getWriter().write("[]");
        }
    }
}
