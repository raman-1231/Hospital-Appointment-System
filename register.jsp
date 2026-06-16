<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="includes/header.jsp" %>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-7 col-lg-6">
            <div class="card shadow-lg" data-testid="register-card">
                <div class="card-header text-center">
                    <h3 data-testid="register-title"><i class="fas fa-user-plus"></i> Patient Registration</h3>
                </div>
                <div class="card-body p-4">
                    
                    <!-- Display Error Message -->
                    <% if (request.getAttribute("error") != null) { %>
                        <div class="alert alert-danger" data-testid="register-error-message">
                            <i class="fas fa-exclamation-circle"></i> <%= request.getAttribute("error") %>
                        </div>
                    <% } %>
                    
                    <!-- Registration Form -->
                    <form action="RegisterServlet" method="post" onsubmit="return validateRegisterForm()" data-testid="register-form">
                        
                        <!-- Full Name -->
                        <div class="mb-3">
                            <label for="name" class="form-label">
                                <i class="fas fa-user"></i> Full Name *
                            </label>
                            <input type="text" class="form-control" id="name" name="name" 
                                   placeholder="Enter your full name" required 
                                   onchange="capitalizeName(this)" data-testid="register-name-input">
                        </div>
                        
                        <!-- Email -->
                        <div class="mb-3">
                            <label for="email" class="form-label">
                                <i class="fas fa-envelope"></i> Email Address *
                            </label>
                            <input type="email" class="form-control" id="email" name="email" 
                                   placeholder="Enter your email" required data-testid="register-email-input">
                        </div>
                        
                        <!-- Phone Number -->
                        <div class="mb-3">
                            <label for="phone" class="form-label">
                                <i class="fas fa-phone"></i> Phone Number
                            </label>
                            <input type="tel" class="form-control" id="phone" name="phone" 
                                   placeholder="Enter your phone number" 
                                   maxlength="10" oninput="formatPhoneNumber(this)" data-testid="register-phone-input">
                        </div>
                        
                        <!-- Password -->
                        <div class="mb-3">
                            <label for="password" class="form-label">
                                <i class="fas fa-lock"></i> Password *
                            </label>
                            <input type="password" class="form-control" id="password" name="password" 
                                   placeholder="Enter password (min 6 characters)" required data-testid="register-password-input">
                            <small class="text-muted">Password must be at least 6 characters long</small>
                        </div>
                        
                        <!-- Confirm Password -->
                        <div class="mb-3">
                            <label for="confirmPassword" class="form-label">
                                <i class="fas fa-lock"></i> Confirm Password *
                            </label>
                            <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" 
                                   placeholder="Re-enter your password" required data-testid="register-confirm-password-input">
                        </div>
                        
                        <!-- Submit Button -->
                        <div class="d-grid mt-4">
                            <button type="submit" class="btn btn-success btn-lg" data-testid="register-submit-btn">
                                <i class="fas fa-user-plus"></i> Register
                            </button>
                        </div>
                    </form>
                    
                    <!-- Login Link -->
                    <div class="text-center mt-4">
                        <p class="mb-0">Already have an account? 
                            <a href="login.jsp" class="text-primary fw-bold" data-testid="register-login-link">
                                Login here
                            </a>
                        </p>
                    </div>
                    
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="includes/footer.jsp" %>