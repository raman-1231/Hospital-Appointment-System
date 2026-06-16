<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.healthcare.dao.DoctorDAO" %>
<%@ page import="com.healthcare.dao.AvailabilityDAO" %>
<%@ page import="com.healthcare.model.Doctor" %>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.Date" %>

<%
    // Check if user is logged in
    if (session.getAttribute("userId") == null || !"patient".equals(session.getAttribute("userType"))) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    DoctorDAO doctorDAO = new DoctorDAO();
    List<Doctor> doctors = doctorDAO.getAllDoctors();
    
    String preselectedDoctorIdStr = request.getParameter("doctorId");
    int preselectedDoctorId = -1;
    if (preselectedDoctorIdStr != null) {
        try {
            preselectedDoctorId = Integer.parseInt(preselectedDoctorIdStr);
        } catch (NumberFormatException e) {
            // ignore
        }
    }
%>

<%@ include file="includes/header.jsp" %>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card shadow-lg" data-testid="book-appointment-card">
                <div class="card-header text-center">
                    <h3 data-testid="book-appointment-title">
                        <i class="fas fa-calendar-plus"></i> Book Appointment
                    </h3>
                </div>
                <div class="card-body p-4">
                    
                    <!-- Display Success Message -->
                    <% if (request.getAttribute("success") != null) { %>
                        <div class="alert alert-success" data-testid="booking-success-message">
                            <i class="fas fa-check-circle"></i> <%= request.getAttribute("success") %>
                        </div>
                    <% } %>
                    
                    <!-- Display Error Message -->
                    <% if (request.getAttribute("error") != null) { %>
                        <div class="alert alert-danger" data-testid="booking-error-message">
                            <i class="fas fa-exclamation-circle"></i> <%= request.getAttribute("error") %>
                        </div>
                    <% } %>
                    
                    <!-- Appointment Booking Form -->
                    <form action="BookAppointmentServlet" method="post" onsubmit="return validateAppointmentForm()" data-testid="book-appointment-form">
                        
                        <!-- Select Doctor -->
                        <div class="mb-4">
                            <label for="doctorId" class="form-label">
                                <i class="fas fa-user-md"></i> Select Doctor *
                            </label>
                            <select class="form-select" id="doctorId" name="doctorId" required 
                                    onchange="loadTimeSlots()" data-testid="select-doctor">
                                <option value="">Select Doctor</option>
                                <% for (Doctor doctor : doctors) { %>
                                    <option value="<%= doctor.getId() %>" <%= (doctor.getId() == preselectedDoctorId) ? "selected" : "" %> data-testid="doctor-option-<%= doctor.getId() %>">
                                        <%= doctor.getDoctorName() %> - <%= doctor.getSpecialization() %>
                                    </option>
                                <% } %>
                            </select>
                        </div>
                        
                        <!-- Appointment Date -->
                        <div class="mb-4">
                            <label for="appointmentDate" class="form-label">
                                <i class="fas fa-calendar"></i> Appointment Date *
                            </label>
                            <input type="date" class="form-control" id="appointmentDate" name="appointmentDate" 
                                   required onchange="loadTimeSlots()" data-testid="select-date">
                            <small class="text-muted">Please select a future date</small>
                        </div>
                        
                        <!-- Time Slot -->
                        <div class="mb-4">
                            <label for="timeSlot" class="form-label">
                                <i class="fas fa-clock"></i> Time Slot *
                            </label>
                            <select class="form-select" id="timeSlot" name="timeSlot" required data-testid="select-time-slot">
                                <option value="">First select doctor and date</option>
                            </select>
                            <small class="text-muted">Available time slots will appear after selecting doctor and date</small>
                        </div>
                        
                        <!-- Reason for Visit -->
                        <div class="mb-4">
                            <label for="reason" class="form-label">
                                <i class="fas fa-notes-medical"></i> Reason for Visit
                            </label>
                            <textarea class="form-control" id="reason" name="reason" rows="3" 
                                      placeholder="Briefly describe your health concern or reason for appointment" data-testid="reason-input"></textarea>
                        </div>
                        
                        <!-- Submit Button -->
                        <div class="d-grid">
                            <button type="submit" class="btn btn-success btn-lg" data-testid="book-appointment-submit-btn">
                                <i class="fas fa-calendar-check"></i> Book Appointment
                            </button>
                        </div>
                    </form>
                    
                    <!-- Back to Dashboard Link -->
                    <div class="text-center mt-4">
                        <a href="dashboard.jsp" class="text-primary" data-testid="back-to-dashboard-link">
                            <i class="fas fa-arrow-left"></i> Back to Dashboard
                        </a>
                    </div>
                    
                </div>
            </div>
            
            <!-- Instructions Card -->
            <div class="card mt-4" data-testid="instructions-card">
                <div class="card-header">
                    <h5><i class="fas fa-info-circle"></i> Important Information</h5>
                </div>
                <div class="card-body">
                    <ul class="mb-0">
                        <li>Please arrive 15 minutes before your scheduled appointment time.</li>
                        <li>Bring any relevant medical records or prescriptions.</li>
                        <li>You will receive a confirmation once your appointment is booked.</li>
                        <li>To cancel or reschedule, please contact us at least 24 hours in advance.</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
// Load available time slots based on doctor and date selection
function loadTimeSlots() {
    const doctorId = document.getElementById('doctorId').value;
    const appointmentDate = document.getElementById('appointmentDate').value;
    const timeSlotSelect = document.getElementById('timeSlot');
    
    if (!doctorId || !appointmentDate) {
        timeSlotSelect.innerHTML = '<option value="">First select doctor and date</option>';
        return;
    }
    
    // Show loading
    timeSlotSelect.innerHTML = '<option value="">Loading available slots...</option>';
    
    // Make AJAX call to get available slots
    fetch('GetAvailableSlotsServlet?doctorId=' + doctorId + '&date=' + appointmentDate)
        .then(response => response.json())
        .then(data => {
            timeSlotSelect.innerHTML = '<option value="">Select Time Slot</option>';
            
            if (data.length === 0) {
                timeSlotSelect.innerHTML = '<option value="">No slots available for selected date</option>';
            } else {
                data.forEach((slot, index) => {
                    const option = document.createElement('option');
                    option.value = slot.timeSlot;
                    option.textContent = slot.timeSlot;
                    option.setAttribute('data-testid', 'time-slot-option-' + index);
                    timeSlotSelect.appendChild(option);
                });
            }
        })
        .catch(error => {
            console.error('Error loading time slots:', error);
            // Fallback: Show common time slots if AJAX fails
            timeSlotSelect.innerHTML = '<option value="">Select Time Slot</option>';
            const defaultSlots = ['09:00 AM', '10:00 AM', '11:00 AM', '02:00 PM', '03:00 PM', '04:00 PM'];
            defaultSlots.forEach((slot, index) => {
                const option = document.createElement('option');
                option.value = slot;
                option.textContent = slot;
                option.setAttribute('data-testid', 'time-slot-option-' + index);
                timeSlotSelect.appendChild(option);
        });
}

document.addEventListener("DOMContentLoaded", function() {
    const docSelect = document.getElementById("doctorId");
    const dateInput = document.getElementById("appointmentDate");
    if (docSelect && docSelect.value && dateInput && dateInput.value) {
        loadTimeSlots();
    }
});
</script>

<%@ include file="includes/footer.jsp" %>