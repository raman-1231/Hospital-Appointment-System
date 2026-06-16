<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.healthcare.dao.DoctorDAO" %>
<%@ page import="com.healthcare.model.Doctor" %>
<%@ page import="java.util.List" %>

<%@ include file="includes/header.jsp" %>

<!-- Hero Section -->
<section class="hero-section">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-lg-6">
                <h1 class="display-4 fw-bold" data-testid="hero-title">Your Health, Our Priority</h1>
                <p class="lead" data-testid="hero-subtitle">Book appointments with expert doctors instantly. Quality healthcare made accessible and convenient.</p>
                <div class="mt-4">
                    <a href="register.jsp" class="btn btn-primary btn-lg me-3" data-testid="get-started-btn">
                        <i class="fas fa-rocket"></i> Get Started
                    </a>
                    <a href="login.jsp" class="btn btn-outline-primary btn-lg" data-testid="login-btn">
                        <i class="fas fa-sign-in-alt"></i> Login
                    </a>
                </div>
            </div>
            <div class="col-lg-6 text-center">
                <i class="fas fa-hospital-user" style="font-size: 15rem; color: rgba(255,255,255,0.9);"></i>
            </div>
        </div>
    </div>
</section>

<!-- Features Section -->
<section class="py-5">
    <div class="container">
        <div class="text-center mb-5">
            <h2 class="display-5 fw-bold text-primary-custom" data-testid="features-title">Why Choose HealthCare+?</h2>
            <p class="lead text-secondary">Experience the future of healthcare management</p>
        </div>
        
        <div class="row g-4">
            <div class="col-md-4" data-testid="feature-easy-booking">
                <div class="feature-card">
                    <i class="fas fa-calendar-check"></i>
                    <h4>Easy Booking</h4>
                    <p>Book appointments with just a few clicks. Simple, fast, and hassle-free.</p>
                </div>
            </div>
            <div class="col-md-4" data-testid="feature-expert-doctors">
                <div class="feature-card">
                    <i class="fas fa-user-md"></i>
                    <h4>Expert Doctors</h4>
                    <p>Access to highly qualified and experienced medical professionals.</p>
                </div>
            </div>
            <div class="col-md-4" data-testid="feature-secure-system">
                <div class="feature-card">
                    <i class="fas fa-shield-alt"></i>
                    <h4>Secure System</h4>
                    <p>Your health data is protected with advanced security measures.</p>
                </div>
            </div>
        </div>
        
        <div class="row g-4 mt-3">
            <div class="col-md-4" data-testid="feature-availability">
                <div class="feature-card">
                    <i class="fas fa-clock"></i>
                    <h4>24/7 Availability</h4>
                    <p>Book appointments anytime, anywhere at your convenience.</p>
                </div>
            </div>
            <div class="col-md-4" data-testid="feature-instant-confirmation">
                <div class="feature-card">
                    <i class="fas fa-check-circle"></i>
                    <h4>Instant Confirmation</h4>
                    <p>Receive immediate confirmation for your scheduled appointments.</p>
                </div>
            </div>
            <div class="col-md-4" data-testid="feature-management">
                <div class="feature-card">
                    <i class="fas fa-tasks"></i>
                    <h4>Easy Management</h4>
                    <p>View and manage all your appointments in one place.</p>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Our Doctors Section -->
<section class="py-5 bg-light">
    <div class="container">
        <div class="text-center mb-5">
            <h2 class="display-5 fw-bold text-primary-custom" data-testid="doctors-title">Our Expert Doctors</h2>
            <p class="lead text-secondary">Meet our team of highly qualified healthcare professionals</p>
        </div>
        
        <div class="row g-4">
            <%
                DoctorDAO doctorDAO = new DoctorDAO();
                List<Doctor> doctors = doctorDAO.getAllDoctors();
                
                int count = 0;
                for (Doctor doctor : doctors) {
                    if (count >= 6) break; // Show only 6 doctors on home page
            %>
                <div class="col-md-4" data-testid="doctor-card-<%= count %>">
                    <div class="card doctor-card">
                        <div class="card-body text-center">
                            <i class="fas fa-user-md" style="font-size: 4rem; color: var(--primary-color);"></i>
                            <h5 class="mt-3 mb-2" data-testid="doctor-name-<%= count %>"><%= doctor.getDoctorName() %></h5>
                            <span class="doctor-badge" data-testid="doctor-specialization-<%= count %>"><%= doctor.getSpecialization() %></span>
                            <p class="mt-3 mb-2 text-secondary">
                                <i class="fas fa-briefcase"></i> <%= doctor.getExperienceYears() %> years experience
                            </p>
                            <% if (doctor.getPhone() != null && !doctor.getPhone().isEmpty()) { %>
                                <p class="text-secondary">
                                    <i class="fas fa-phone"></i> <%= doctor.getPhone() %>
                                </p>
                            <% } %>
                            <a href="register.jsp" class="btn btn-primary btn-sm mt-2" data-testid="book-doctor-btn-<%= count %>">
                                <i class="fas fa-calendar-plus"></i> Book Appointment
                            </a>
                        </div>
                    </div>
                </div>
            <%
                    count++;
                }
                
                if (doctors.isEmpty()) {
            %>
                <div class="col-12">
                    <div class="alert alert-info text-center">
                        <i class="fas fa-info-circle"></i> No doctors available at the moment.
                    </div>
                </div>
            <%
                }
            %>
        </div>
        
        <% if (doctors.size() > 6) { %>
            <div class="text-center mt-4">
                <a href="register.jsp" class="btn btn-outline-primary" data-testid="view-all-doctors-btn">
                    View All Doctors <i class="fas fa-arrow-right"></i>
                </a>
            </div>
        <% } %>
    </div>
</section>

<!-- How It Works Section -->
<section class="py-5">
    <div class="container">
        <div class="text-center mb-5">
            <h2 class="display-5 fw-bold text-primary-custom" data-testid="how-it-works-title">How It Works</h2>
            <p class="lead text-secondary">Simple steps to book your appointment</p>
        </div>
        
        <div class="row g-4">
            <div class="col-md-3 text-center" data-testid="step-1">
                <div class="feature-card">
                    <div class="display-4 fw-bold text-primary-custom mb-3">1</div>
                    <h5>Register</h5>
                    <p>Create your account with basic information</p>
                </div>
            </div>
            <div class="col-md-3 text-center" data-testid="step-2">
                <div class="feature-card">
                    <div class="display-4 fw-bold text-primary-custom mb-3">2</div>
                    <h5>Choose Doctor</h5>
                    <p>Select from our list of expert doctors</p>
                </div>
            </div>
            <div class="col-md-3 text-center" data-testid="step-3">
                <div class="feature-card">
                    <div class="display-4 fw-bold text-primary-custom mb-3">3</div>
                    <h5>Pick Date & Time</h5>
                    <p>Select your preferred appointment slot</p>
                </div>
            </div>
            <div class="col-md-3 text-center" data-testid="step-4">
                <div class="feature-card">
                    <div class="display-4 fw-bold text-primary-custom mb-3">4</div>
                    <h5>Get Confirmation</h5>
                    <p>Receive instant confirmation for your booking</p>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- CTA Section -->
<section class="py-5 bg-gradient-primary text-white">
    <div class="container text-center">
        <h2 class="display-5 fw-bold mb-3" data-testid="cta-title">Ready to Get Started?</h2>
        <p class="lead mb-4">Join thousands of patients who trust HealthCare+ for their medical needs</p>
        <a href="register.jsp" class="btn btn-light btn-lg" data-testid="cta-register-btn">
            <i class="fas fa-user-plus"></i> Register Now
        </a>
    </div>
</section>

<%@ include file="includes/footer.jsp" %>