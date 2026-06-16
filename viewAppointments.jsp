<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.healthcare.dao.AppointmentDAO" %>
<%@ page import="com.healthcare.model.Appointment" %>
<%@ page import="java.util.List" %>

<%
    // Check if user is logged in
    if (session.getAttribute("userId") == null || !"patient".equals(session.getAttribute("userType"))) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    int userId = (Integer) session.getAttribute("userId");
    
    // Get user appointments
    AppointmentDAO appointmentDAO = new AppointmentDAO();
    List<Appointment> appointments = appointmentDAO.getAppointmentsByUserId(userId);
%>

<%@ include file="includes/header.jsp" %>

<div class="container py-5">
    <div class="row">
        <div class="col-12">
            <div class="card shadow-lg" data-testid="appointments-card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h3 class="mb-0" data-testid="appointments-title">
                        <i class="fas fa-calendar-check"></i> My Appointments
                    </h3>
                    <a href="bookAppointment.jsp" class="btn btn-primary" data-testid="book-new-appointment-btn">
                        <i class="fas fa-plus"></i> Book New
                    </a>
                </div>
                <div class="card-body p-4">
                    
                    <!-- Display Success Message -->
                    <% if (request.getAttribute("success") != null) { %>
                        <div class="alert alert-success" data-testid="appointments-success-message">
                            <i class="fas fa-check-circle"></i> <%= request.getAttribute("success") %>
                        </div>
                    <% } %>
                    
                    <% if (appointments.isEmpty()) { %>
                        <!-- No Appointments -->
                        <div class="text-center py-5" data-testid="no-appointments-message">
                            <i class="fas fa-calendar-times" style="font-size: 5rem; color: var(--primary-color); opacity: 0.5;"></i>
                            <h4 class="mt-4 mb-3">No Appointments Yet</h4>
                            <p class="text-secondary mb-4">You haven't booked any appointments. Start by booking your first appointment.</p>
                            <a href="bookAppointment.jsp" class="btn btn-primary btn-lg" data-testid="book-first-appointment-btn">
                                <i class="fas fa-calendar-plus"></i> Book Your First Appointment
                            </a>
                        </div>
                    <% } else { %>
                        <!-- Appointments Table -->
                        <div class="table-responsive" data-testid="appointments-table">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th data-testid="table-header-id">ID</th>
                                        <th data-testid="table-header-doctor">Doctor</th>
                                        <th data-testid="table-header-specialization">Specialization</th>
                                        <th data-testid="table-header-date">Date</th>
                                        <th data-testid="table-header-time">Time</th>
                                        <th data-testid="table-header-status">Status</th>
                                        <th data-testid="table-header-reason">Reason</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% 
                                        int count = 0;
                                        for (Appointment appointment : appointments) { 
                                    %>
                                        <tr data-testid="appointment-row-<%= count %>">
                                            <td data-testid="appointment-id-<%= count %>"><%= appointment.getId() %></td>
                                            <td data-testid="appointment-doctor-<%= count %>">
                                                <i class="fas fa-user-md text-primary"></i> <%= appointment.getDoctorName() %>
                                            </td>
                                            <td data-testid="appointment-spec-<%= count %>">
                                                <span class="badge bg-secondary"><%= appointment.getSpecialization() %></span>
                                            </td>
                                            <td data-testid="appointment-date-<%= count %>">
                                                <i class="fas fa-calendar"></i> <%= appointment.getAppointmentDate() %>
                                            </td>
                                            <td data-testid="appointment-time-<%= count %>">
                                                <i class="fas fa-clock"></i> <%= appointment.getTimeSlot() %>
                                            </td>
                                            <td data-testid="appointment-status-<%= count %>">
                                                <% 
                                                    String status = appointment.getStatus();
                                                    String badgeClass = "badge-scheduled";
                                                    String icon = "fa-calendar-check";
                                                    
                                                    if ("completed".equals(status)) {
                                                        badgeClass = "badge-completed";
                                                        icon = "fa-check-circle";
                                                    } else if ("cancelled".equals(status)) {
                                                        badgeClass = "badge-cancelled";
                                                        icon = "fa-times-circle";
                                                    }
                                                %>
                                                <span class="badge <%= badgeClass %>">
                                                    <i class="fas <%= icon %>"></i> <%= status.substring(0, 1).toUpperCase() + status.substring(1) %>
                                                </span>
                                            </td>
                                            <td data-testid="appointment-reason-<%= count %>">
                                                <%= appointment.getReason() != null && !appointment.getReason().isEmpty() ? appointment.getReason() : "N/A" %>
                                            </td>
                                        </tr>
                                    <%
                                            count++;
                                        }
                                    %>
                                </tbody>
                            </table>
                        </div>
                        
                        <!-- Summary -->
                        <div class="mt-4 p-3" style="background: rgba(14, 165, 233, 0.1); border-radius: 10px;" data-testid="appointments-summary">
                            <p class="mb-0">
                                <strong><i class="fas fa-info-circle"></i> Total Appointments:</strong> <%= appointments.size() %>
                            </p>
                        </div>
                    <% } %>
                    
                    <!-- Back to Dashboard Link -->
                    <div class="text-center mt-4">
                        <a href="dashboard.jsp" class="text-primary" data-testid="back-to-dashboard-link">
                            <i class="fas fa-arrow-left"></i> Back to Dashboard
                        </a>
                    </div>
                    
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="includes/footer.jsp" %>