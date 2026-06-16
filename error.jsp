<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<%@ include file="includes/header.jsp" %>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card shadow-lg text-center" data-testid="error-card">
                <div class="card-body p-5">
                    <i class="fas fa-exclamation-triangle" style="font-size: 5rem; color: var(--danger-color);"></i>
                    <h2 class="mt-4 mb-3" data-testid="error-title">Oops! Something Went Wrong</h2>
                    <p class="text-secondary mb-4" data-testid="error-message">
                        We're sorry, but the page you're looking for doesn't exist or an error occurred.
                    </p>
                    <a href="index.jsp" class="btn btn-primary" data-testid="back-home-btn">
                        <i class="fas fa-home"></i> Back to Home
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="includes/footer.jsp" %>