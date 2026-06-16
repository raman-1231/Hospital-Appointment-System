<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.healthcare.dao.DoctorDAO" %>
<%@ page import="com.healthcare.dao.AppointmentDAO" %>
<%@ page import="com.healthcare.dao.AvailabilityDAO" %>
<%@ page import="com.healthcare.model.Doctor" %>
<%@ page import="java.util.List" %>

<%
    // Check if user is logged in
    if (session.getAttribute("userId") == null || !"patient".equals(session.getAttribute("userType"))) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    int userId = (Integer) session.getAttribute("userId");
    
    // Get statistics
    AppointmentDAO appointmentDAO = new AppointmentDAO();
    int totalAppointments = appointmentDAO.getAppointmentCount(userId);
    
    DoctorDAO doctorDAO = new DoctorDAO();
    List<Doctor> doctors = doctorDAO.getAllDoctors();
    
    // Generate upcoming availability slots automatically
    AvailabilityDAO availabilityDAO = new AvailabilityDAO();
    availabilityDAO.generateUpcomingSlots();
%>

<%@ include file="includes/header.jsp" %>

<div class="container py-5">
    <!-- Welcome Section -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="card" style="background: linear-gradient(135deg, var(--primary-color), var(--primary-dark)); color: white;" data-testid="welcome-card">
                <div class="card-body p-4">
                    <h2 class="mb-2" data-testid="welcome-message">
                        <i class="fas fa-hand-wave"></i> Welcome back, <%= userName %>!
                    </h2>
                    <p class="mb-0">Manage your appointments and healthcare needs from your dashboard.</p>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Statistics Cards -->
    <div class="row g-4 mb-5">
        <div class="col-md-4" data-testid="stat-appointments">
            <a href="viewAppointments.jsp" class="text-decoration-none d-block">
                <div class="stat-card">
                    <i class="fas fa-calendar-check"></i>
                    <h3 data-testid="total-appointments-count"><%= totalAppointments %></h3>
                    <p>Total Appointments</p>
                </div>
            </a>
        </div>
        <div class="col-md-4" data-testid="stat-doctors">
            <a href="#doctors-section" class="text-decoration-none d-block">
                <div class="stat-card" style="background: linear-gradient(135deg, var(--accent-color), var(--success-color));">
                    <i class="fas fa-user-md"></i>
                    <h3 data-testid="available-doctors-count"><%= doctors.size() %></h3>
                    <p>Available Doctors</p>
                </div>
            </a>
        </div>
        <div class="col-md-4" data-testid="stat-specializations">
            <a href="#doctors-section" class="text-decoration-none d-block">
                <div class="stat-card" style="background: linear-gradient(135deg, var(--secondary-color), var(--primary-light));">
                    <i class="fas fa-stethoscope"></i>
                    <h3 data-testid="specializations-count"><%= doctors.stream().map(d -> d.getSpecialization()).distinct().count() %></h3>
                    <p>Specializations</p>
                </div>
            </a>
        </div>
    </div>
    
    <!-- Quick Actions -->
    <div class="row mb-5">
        <div class="col-12">
            <h3 class="mb-4" data-testid="quick-actions-title">
                <i class="fas fa-bolt"></i> Quick Actions
            </h3>
        </div>
        <div class="col-md-6 mb-3">
            <a href="bookAppointment.jsp" class="text-decoration-none" data-testid="quick-book-appointment">
                <div class="card hover-lift" style="cursor: pointer;">
                    <div class="card-body p-4 d-flex align-items-center">
                        <div class="me-4" style="font-size: 3rem; color: var(--primary-color);">
                            <i class="fas fa-calendar-plus"></i>
                        </div>
                        <div>
                            <h5 class="mb-2">Book New Appointment</h5>
                            <p class="mb-0 text-secondary">Schedule an appointment with our doctors</p>
                        </div>
                        <div class="ms-auto">
                            <i class="fas fa-arrow-right" style="font-size: 1.5rem; color: var(--primary-color);"></i>
                        </div>
                    </div>
                </div>
            </a>
        </div>
        <div class="col-md-6 mb-3">
            <a href="viewAppointments.jsp" class="text-decoration-none" data-testid="quick-view-appointments">
                <div class="card hover-lift" style="cursor: pointer;">
                    <div class="card-body p-4 d-flex align-items-center">
                        <div class="me-4" style="font-size: 3rem; color: var(--accent-color);">
                            <i class="fas fa-list-alt"></i>
                        </div>
                        <div>
                            <h5 class="mb-2">View My Appointments</h5>
                            <p class="mb-0 text-secondary">Check your scheduled appointments</p>
                        </div>
                        <div class="ms-auto">
                            <i class="fas fa-arrow-right" style="font-size: 1.5rem; color: var(--accent-color);"></i>
                        </div>
                    </div>
                </div>
            </a>
        </div>
    </div>
    
    <!-- Available Doctors -->
    <div class="row" id="doctors-section">
        <div class="col-12">
            <h3 class="mb-4" data-testid="available-doctors-title">
                <i class="fas fa-user-doctor"></i> Our Expert Doctors
            </h3>
        </div>
        
        <% 
            int count = 0;
            for (Doctor doctor : doctors) {
                if (count >= 3) break; // Show only 3 doctors on dashboard
        %>
            <div class="col-md-4 mb-4" data-testid="dashboard-doctor-card-<%= count %>">
                <div class="card doctor-card">
                    <div class="card-body text-center">
                        <i class="fas fa-user-md" style="font-size: 4rem; color: var(--primary-color);"></i>
                        <h5 class="mt-3 mb-2" data-testid="dashboard-doctor-name-<%= count %>"><%= doctor.getDoctorName() %></h5>
                        <span class="doctor-badge" data-testid="dashboard-doctor-spec-<%= count %>"><%= doctor.getSpecialization() %></span>
                        <p class="mt-3 mb-2 text-secondary">
                            <i class="fas fa-briefcase"></i> <%= doctor.getExperienceYears() %> years experience
                        </p>
                        <a href="bookAppointment.jsp?doctorId=<%= doctor.getId() %>" class="btn btn-primary btn-sm mt-2" data-testid="dashboard-book-btn-<%= count %>">
                            <i class="fas fa-calendar-plus"></i> Book Appointment
                        </a>
                    </div>
                </div>
            </div>
        <%
                count++;
            }
        %>
        
        <% if (doctors.size() > 3) { %>
            <div class="col-12 text-center mt-3">
                <button class="btn btn-outline-primary" data-bs-toggle="modal" data-bs-target="#allDoctorsModal" data-testid="view-all-doctors-btn">
                    View All Doctors <i class="fas fa-arrow-right"></i>
                </button>
            </div>
        <% } %>
    </div>
</div>

<!-- View All Doctors Modal -->
<div class="modal fade" id="allDoctorsModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="fas fa-user-doctor"></i> Our Expert Doctors</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="row g-4">
                    <% for (Doctor doctor : doctors) { %>
                        <div class="col-md-6">
                            <div class="card h-100 shadow-sm border-0 bg-light">
                                <div class="card-body text-center p-4">
                                    <i class="fas fa-user-md" style="font-size: 3rem; color: var(--primary-color);"></i>
                                    <h5 class="mt-3 mb-1"><%= doctor.getDoctorName() %></h5>
                                    <span class="doctor-badge mb-3"><%= doctor.getSpecialization() %></span>
                                    <p class="text-secondary mb-3">
                                        <i class="fas fa-briefcase"></i> <%= doctor.getExperienceYears() %> years experience
                                    </p>
                                    <a href="bookAppointment.jsp?doctorId=<%= doctor.getId() %>" class="btn btn-primary btn-sm w-100">
                                        <i class="fas fa-calendar-plus"></i> Book Appointment
                                    </a>
                                </div>
                            </div>
                        </div>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="includes/footer.jsp" %>