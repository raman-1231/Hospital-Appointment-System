<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="includes/header.jsp" %>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-6 col-lg-5">
            <div class="card shadow-lg" data-testid="login-card">
                <div class="card-header text-center">
                    <h3 data-testid="login-title"><i class="fas fa-sign-in-alt"></i> Login</h3>
                </div>
                <div class="card-body p-4">
                    
                    <!-- Display Error Message -->
                    <% if (request.getAttribute("error") != null) { %>
                        <div class="alert alert-danger" data-testid="login-error-message">
                            <i class="fas fa-exclamation-circle"></i> <%= request.getAttribute("error") %>
                        </div>
                    <% } %>
                    
                    <!-- Display Success Message -->
                    <% if (request.getAttribute("success") != null) { %>
                        <div class="alert alert-success" data-testid="login-success-message">
                            <i class="fas fa-check-circle"></i> <%= request.getAttribute("success") %>
                        </div>
                    <% } %>
                    
                    <!-- Login Form -->
                    <form action="LoginServlet" method="post" onsubmit="return validateLoginForm()" data-testid="login-form">
                        
                        <!-- User Type Selection -->
                        <div class="mb-4">
                            <label class="form-label">Login As</label>
                            <div class="d-flex gap-3">
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="userType" id="patientRadio" value="patient" checked data-testid="login-type-patient">
                                    <label class="form-check-label" for="patientRadio">
                                        <i class="fas fa-user"></i> Patient
                                    </label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="userType" id="adminRadio" value="admin" data-testid="login-type-admin">
                                    <label class="form-check-label" for="adminRadio">
                                        <i class="fas fa-user-shield"></i> Admin
                                    </label>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Email Input -->
                        <div class="mb-3">
                            <label for="email" class="form-label">
                                <i class="fas fa-envelope"></i> Email Address
                            </label>
                            <input type="email" class="form-control" id="email" name="email" 
                                   placeholder="Enter your email" required data-testid="login-email-input">
                        </div>
                        
                        <!-- Password Input -->
                        <div class="mb-3">
                            <label for="password" class="form-label">
                                <i class="fas fa-lock"></i> Password
                            </label>
                            <input type="password" class="form-control" id="password" name="password" 
                                   placeholder="Enter your password" required data-testid="login-password-input">
                        </div>
                        
                        <!-- Submit Button -->
                        <div class="d-grid">
                            <button type="submit" class="btn btn-primary btn-lg" data-testid="login-submit-btn">
                                <i class="fas fa-sign-in-alt"></i> Login
                            </button>
                        </div>
                    </form>
                    
                    <!-- Register Link -->
                    <div class="text-center mt-4">
                        <p class="mb-0">Don't have an account? 
                            <a href="register.jsp" class="text-primary fw-bold" data-testid="login-register-link">
                                Register here
                            </a>
                        </p>
                    </div>
                    
                    <!-- Admin Credentials Info -->
                    <div class="mt-4 p-3" style="background: rgba(14, 165, 233, 0.1); border-radius: 10px; border-left: 4px solid var(--primary-color);">
                        <small>
                            <strong><i class="fas fa-info-circle"></i> Admin Login:</strong><br>
                            Email: admin@healthcare.com<br>
                            Password: admin123
                        </small>
                    </div>
                    
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="includes/footer.jsp" %>