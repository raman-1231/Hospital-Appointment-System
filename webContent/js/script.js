// Healthcare Appointment System - JavaScript Functions
// Form Validation and Interactive Features

// Form Validation for Registration
function validateRegisterForm() {
    const name = document.getElementById('name').value.trim();
    const email = document.getElementById('email').value.trim();
    const password = document.getElementById('password').value;
    const confirmPassword = document.getElementById('confirmPassword').value;
    const phone = document.getElementById('phone').value.trim();
    
    // Name validation
    if (name === '') {
        showError('Name is required!');
        return false;
    }
    
    if (name.length < 3) {
        showError('Name must be at least 3 characters long!');
        return false;
    }
    
    // Email validation
    if (email === '') {
        showError('Email is required!');
        return false;
    }
    
    const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailPattern.test(email)) {
        showError('Please enter a valid email address!');
        return false;
    }
    
    // Password validation
    if (password === '') {
        showError('Password is required!');
        return false;
    }
    
    if (password.length < 6) {
        showError('Password must be at least 6 characters long!');
        return false;
    }
    
    // Confirm password validation
    if (password !== confirmPassword) {
        showError('Passwords do not match!');
        return false;
    }
    
    // Phone validation (optional but if provided should be valid)
    if (phone !== '') {
        const phonePattern = /^[0-9]{10}$/;
        if (!phonePattern.test(phone.replace(/[-\s]/g, ''))) {
            showError('Please enter a valid 10-digit phone number!');
            return false;
        }
    }
    
    return true;
}

// Form Validation for Login
function validateLoginForm() {
    const email = document.getElementById('email').value.trim();
    const password = document.getElementById('password').value;
    
    if (email === '') {
        showError('Email is required!');
        return false;
    }
    
    const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailPattern.test(email)) {
        showError('Please enter a valid email address!');
        return false;
    }
    
    if (password === '') {
        showError('Password is required!');
        return false;
    }
    
    return true;
}

// Form Validation for Booking Appointment
function validateAppointmentForm() {
    const doctorId = document.getElementById('doctorId').value;
    const appointmentDate = document.getElementById('appointmentDate').value;
    const timeSlot = document.getElementById('timeSlot').value;
    
    if (doctorId === '' || doctorId === 'Select Doctor') {
        showError('Please select a doctor!');
        return false;
    }
    
    if (appointmentDate === '') {
        showError('Please select an appointment date!');
        return false;
    }
    
    // Check if date is in the future
    const selectedDate = new Date(appointmentDate);
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    
    if (selectedDate < today) {
        showError('Please select a future date!');
        return false;
    }
    
    if (timeSlot === '' || timeSlot === 'Select Time Slot') {
        showError('Please select a time slot!');
        return false;
    }
    
    return true;
}

// Form Validation for Adding Doctor
function validateDoctorForm() {
    const doctorName = document.getElementById('doctorName').value.trim();
    const specialization = document.getElementById('specialization').value.trim();
    const email = document.getElementById('doctorEmail').value.trim();
    const phone = document.getElementById('doctorPhone').value.trim();
    const experience = document.getElementById('experience').value;
    
    if (doctorName === '') {
        showError('Doctor name is required!');
        return false;
    }
    
    if (specialization === '') {
        showError('Specialization is required!');
        return false;
    }
    
    if (email !== '') {
        const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailPattern.test(email)) {
            showError('Please enter a valid email address!');
            return false;
        }
    }
    
    if (experience !== '' && (isNaN(experience) || experience < 0)) {
        showError('Please enter a valid experience (years)!');
        return false;
    }
    
    return true;
}

// Show Error Message
function showError(message) {
    alert(message);
}

// Show Success Message
function showSuccess(message) {
    alert(message);
}

// Confirm Delete Action
function confirmDelete(itemName) {
    return confirm('Are you sure you want to delete ' + itemName + '?');
}

// Load Available Time Slots based on Doctor and Date
function loadTimeSlots() {
    const doctorId = document.getElementById('doctorId').value;
    const appointmentDate = document.getElementById('appointmentDate').value;
    const timeSlotSelect = document.getElementById('timeSlot');
    
    // Clear existing options
    timeSlotSelect.innerHTML = '<option value="">Select Time Slot</option>';
    
    if (doctorId && appointmentDate) {
        // Show loading
        timeSlotSelect.innerHTML = '<option value="">Loading...</option>';
        
        // Make AJAX call to get available slots
        fetch('GetAvailableSlots?doctorId=' + doctorId + '&date=' + appointmentDate)
            .then(response => response.json())
            .then(data => {
                timeSlotSelect.innerHTML = '<option value="">Select Time Slot</option>';
                
                if (data.length === 0) {
                    timeSlotSelect.innerHTML = '<option value="">No slots available</option>';
                } else {
                    data.forEach(slot => {
                        const option = document.createElement('option');
                        option.value = slot.timeSlot;
                        option.textContent = slot.timeSlot;
                        timeSlotSelect.appendChild(option);
                    });
                }
            })
            .catch(error => {
                console.error('Error loading time slots:', error);
                timeSlotSelect.innerHTML = '<option value="">Error loading slots</option>';
            });
    }
}

// Set minimum date for appointment booking (today)
function setMinDate() {
    const dateInput = document.getElementById('appointmentDate');
    if (dateInput) {
        const today = new Date();
        const tomorrow = new Date(today);
        tomorrow.setDate(tomorrow.getDate() + 1);
        const minDate = tomorrow.toISOString().split('T')[0];
        dateInput.setAttribute('min', minDate);
    }
}

// Auto-dismiss alerts after 5 seconds
function autoDismissAlerts() {
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(alert => {
        setTimeout(() => {
            alert.style.opacity = '0';
            alert.style.transform = 'translateY(-20px)';
            setTimeout(() => {
                alert.remove();
            }, 300);
        }, 5000);
    });
}

// Initialize on page load
document.addEventListener('DOMContentLoaded', function() {
    // Set minimum date for date inputs
    setMinDate();
    
    // Auto-dismiss alerts
    autoDismissAlerts();
    
    // Add smooth scrolling to all links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });
    
    // Add hover effect to cards
    const cards = document.querySelectorAll('.card, .feature-card, .doctor-card');
    cards.forEach(card => {
        card.addEventListener('mouseenter', function() {
            this.style.transition = 'all 0.3s ease';
        });
    });
});

// Password visibility toggle
function togglePassword(inputId) {
    const input = document.getElementById(inputId);
    const icon = event.target;
    
    if (input.type === 'password') {
        input.type = 'text';
        icon.classList.remove('fa-eye');
        icon.classList.add('fa-eye-slash');
    } else {
        input.type = 'password';
        icon.classList.remove('fa-eye-slash');
        icon.classList.add('fa-eye');
    }
}

// Format phone number as user types
function formatPhoneNumber(input) {
    let value = input.value.replace(/\D/g, '');
    if (value.length > 10) {
        value = value.substr(0, 10);
    }
    input.value = value;
}

// Capitalize first letter of name
function capitalizeName(input) {
    let words = input.value.split(' ');
    words = words.map(word => {
        return word.charAt(0).toUpperCase() + word.slice(1).toLowerCase();
    });
    input.value = words.join(' ');
}