<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>

<%@ page import="com.healthcare.dao.DoctorDAO" %>
<%@ page import="com.healthcare.dao.AppointmentDAO" %>
<%@ page import="com.healthcare.dao.UserDAO" %>
<%@ page import="com.healthcare.dao.AvailabilityDAO" %>

<%@ page import="com.healthcare.model.Doctor" %>
<%@ page import="com.healthcare.model.Appointment" %>
<%@ page import="com.healthcare.model.User" %>
<%@ page import="com.healthcare.model.DoctorAvailability" %>

<%
    // Check admin session
    if (session.getAttribute("userType") == null ||
        !"admin".equals(session.getAttribute("userType"))) {

        response.sendRedirect("login.jsp");
        return;
    }

    // DAO Objects
    DoctorDAO doctorDAO =
            new DoctorDAO();

    AppointmentDAO appointmentDAO =
            new AppointmentDAO();

    UserDAO userDAO =
            new UserDAO();

    AvailabilityDAO availabilityDAO =
            new AvailabilityDAO();

    // Fetch Data
    List<Doctor> doctors =
            doctorDAO.getAllDoctors();

    List<Appointment> appointments =
            appointmentDAO.getAllAppointments();

    List<User> patients =
            userDAO.getAllUsers();

    // Automatically generate slots for upcoming days
    availabilityDAO.generateUpcomingSlots();

    List<DoctorAvailability> availabilities =
            availabilityDAO.getAllAvailabilities();

    int totalPatients =
            patients.size();
%>

<%@ include file="includes/header.jsp" %>

<div class="container py-5">

    <!-- Dashboard Header -->
    <div class="row mb-4">

        <div class="col-12">

            <div class="card bg-gradient-primary text-white">

                <div class="card-body p-4">

                    <div class="d-flex justify-content-between align-items-center">

                        <div>

                            <h2 class="mb-2">
                                <i class="fas fa-user-shield"></i>
                                Admin Dashboard
                            </h2>

                            <p class="mb-0">
                                Welcome,
                                <strong><%= userName %></strong>
                            </p>

                        </div>

                        <div>

                            <a href="LogoutServlet"
                               class="btn btn-danger">

                                <i class="fas fa-sign-out-alt"></i>
                                Logout

                            </a>

                        </div>

                    </div>

                </div>

            </div>

        </div>

    </div>

    <!-- Statistics -->
    <div class="row g-4 mb-5">

        <div class="col-md-4">
            <a href="#doctors-section" class="text-decoration-none d-block">
                <div class="stat-card">
                    <i class="fas fa-user-md"></i>
                    <h3>
                        <%= doctors.size() %>
                    </h3>
                    <p>Total Doctors</p>
                </div>
            </a>
        </div>

        <div class="col-md-4">
            <a href="#appointments-section" class="text-decoration-none d-block">
                <div class="stat-card"
                     style="background: linear-gradient(135deg,#10b981,#22c55e);">
                    <i class="fas fa-calendar-check"></i>
                    <h3>
                        <%= appointments.size() %>
                    </h3>
                    <p>Total Appointments</p>
                </div>
            </a>
        </div>

        <div class="col-md-4">
            <a href="#patients-section" class="text-decoration-none d-block">
                <div class="stat-card"
                     style="background: linear-gradient(135deg,#06b6d4,#38bdf8);">
                    <i class="fas fa-users"></i>
                    <h3>
                        <%= totalPatients %>
                    </h3>
                    <p>Total Patients</p>
                </div>
            </a>
        </div>

    </div>

    <!-- Success Message -->
    <% if (request.getAttribute("success") != null) { %>

        <div class="alert alert-success">

            <i class="fas fa-check-circle"></i>

            <%= request.getAttribute("success") %>

        </div>

    <% } %>

    <!-- Error Message -->
    <% if (request.getAttribute("error") != null) { %>

        <div class="alert alert-danger">

            <i class="fas fa-exclamation-circle"></i>

            <%= request.getAttribute("error") %>

        </div>

    <% } %>

    <!-- Doctors Section -->
    <div class="card mb-5" id="doctors-section">

        <div class="card-header d-flex
                    justify-content-between
                    align-items-center">

            <h4 class="mb-0">

                <i class="fas fa-user-md"></i>
                Doctors List

            </h4>

            <button class="btn btn-success"
                    data-bs-toggle="modal"
                    data-bs-target="#addDoctorModal">

                <i class="fas fa-plus"></i>
                Add Doctor

            </button>

        </div>

        <div class="card-body">

            <% if (doctors.isEmpty()) { %>

                <div class="alert alert-info">

                    No doctors available.

                </div>

            <% } else { %>

                <div class="table-responsive">

                    <table class="table table-hover">

                        <thead>

                            <tr>

                                <th>ID</th>
                                <th>Name</th>
                                <th>Specialization</th>
                                <th>Email</th>
                                <th>Phone</th>
                                <th>Experience</th>
                                <th>Actions</th>

                            </tr>

                        </thead>

                        <tbody>

                        <% for (Doctor doctor : doctors) { %>

                            <tr>

                                <td>
                                    <%= doctor.getId() %>
                                </td>

                                <td>
                                    <strong><%= doctor.getDoctorName() %></strong>
                                </td>

                                <td>

                                    <span class="badge bg-primary">

                                        <%= doctor.getSpecialization() %>

                                    </span>

                                </td>

                                <td>
                                    <%= doctor.getEmail() != null
                                            ? doctor.getEmail()
                                            : "N/A" %>
                                </td>

                                <td>
                                    <%= doctor.getPhone() != null
                                            ? doctor.getPhone()
                                            : "N/A" %>
                                </td>

                                <td>
                                    <%= doctor.getExperienceYears() %> Years
                                </td>

                                <td>
                                    <button class="btn btn-warning btn-sm edit-doctor-btn text-white me-2"
                                            data-bs-toggle="modal"
                                            data-bs-target="#editDoctorModal"
                                            data-id="<%= doctor.getId() %>"
                                            data-name="<%= doctor.getDoctorName() %>"
                                            data-specialization="<%= doctor.getSpecialization() %>"
                                            data-email="<%= doctor.getEmail() != null ? doctor.getEmail() : "" %>"
                                            data-phone="<%= doctor.getPhone() != null ? doctor.getPhone() : "" %>"
                                            data-experience="<%= doctor.getExperienceYears() %>">
                                        <i class="fas fa-edit"></i> Edit
                                    </button>

                                    <form action="DoctorManagementServlet"
                                          method="post"
                                          style="display:inline;"
                                          onsubmit="return confirm('Are you sure you want to remove this doctor?');">

                                        <input type="hidden"
                                               name="action"
                                               value="delete">

                                        <input type="hidden"
                                               name="doctorId"
                                               value="<%= doctor.getId() %>">

                                        <button type="submit"
                                                class="btn btn-danger btn-sm">

                                            <i class="fas fa-trash"></i>
                                            Delete

                                        </button>

                                    </form>

                                </td>

                            </tr>

                        <% } %>

                        </tbody>

                    </table>

                </div>

            <% } %>

        </div>

    </div>

    <!-- Doctor Availability Section -->
    <div class="card mb-5" id="availability-section">
        <div class="card-header d-flex justify-content-between align-items-center">
            <h4 class="mb-0">
                <i class="fas fa-calendar-alt"></i>
                Doctor Availability Slots
            </h4>
            <button class="btn btn-success"
                    data-bs-toggle="modal"
                    data-bs-target="#addAvailabilityModal">
                <i class="fas fa-plus"></i>
                Add Availability
            </button>
        </div>
        <div class="card-body">
            <% if (availabilities.isEmpty()) { %>
                <div class="alert alert-info">
                    No availability slots configured.
                </div>
            <% } else { %>
                <!-- Filters -->
                <div class="row g-3 mb-4">
                    <div class="col-md-4">
                        <label class="form-label"><i class="fas fa-filter text-primary"></i> Filter by Doctor</label>
                        <select id="filterDoctor" class="form-select" onchange="filterAvailabilityTable()">
                            <option value="">All Doctors</option>
                            <% for (Doctor d : doctors) { %>
                                <option value="<%= d.getDoctorName() %>"><%= d.getDoctorName() %></option>
                            <% } %>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label"><i class="fas fa-calendar-day text-success"></i> Filter by Day (Date)</label>
                        <select id="filterDate" class="form-select" onchange="filterAvailabilityTable()">
                            <option value="">All Days</option>
                            <% 
                                List<java.sql.Date> distinctDates = new java.util.ArrayList<>();
                                for (DoctorAvailability slot : availabilities) {
                                    if (!distinctDates.contains(slot.getAvailableDate())) {
                                        distinctDates.add(slot.getAvailableDate());
                                    }
                                }
                                distinctDates.sort((d1, d2) -> d2.compareTo(d1));
                                for (java.sql.Date d : distinctDates) {
                            %>
                                <option value="<%= d %>"><%= d %></option>
                            <% } %>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label"><i class="fas fa-info-circle text-info"></i> Filter by Status</label>
                        <select id="filterStatus" class="form-select" onchange="filterAvailabilityTable()">
                            <option value="">All Statuses</option>
                            <option value="Available">Available</option>
                            <option value="Booked">Booked</option>
                        </select>
                    </div>
                </div>

                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>Slot ID</th>
                                <th>Doctor Name</th>
                                <th>Available Date</th>
                                <th>Time Slot</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                        <% for (DoctorAvailability slot : availabilities) { %>
                            <tr class="availability-row" 
                                data-doctor="<%= slot.getDoctorName() %>"
                                data-date="<%= slot.getAvailableDate() %>"
                                data-status="<%= slot.isBooked() ? "Booked" : "Available" %>">
                                <td><%= slot.getId() %></td>
                                <td><strong><%= slot.getDoctorName() %></strong></td>
                                <td><%= slot.getAvailableDate() %></td>
                                <td><span class="badge bg-light text-dark"><i class="fas fa-clock"></i> <%= slot.getTimeSlot() %></span></td>
                                <td>
                                    <% if (slot.isBooked()) { %>
                                        <span class="badge bg-danger text-white">Booked</span>
                                    <% } else { %>
                                        <span class="badge bg-success text-white">Available</span>
                                    <% } %>
                                </td>
                                <td>
                                    <% if (!slot.isBooked()) { %>
                                        <form action="AvailabilityServlet" method="post" style="display:inline;" onsubmit="return confirm('Are you sure you want to remove this availability slot?');">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="availabilityId" value="<%= slot.getId() %>">
                                            <button type="submit" class="btn btn-danger btn-sm">
                                                <i class="fas fa-trash"></i> Delete
                                            </button>
                                        </form>
                                    <% } else { %>
                                        <span class="text-muted">No Actions (Booked)</span>
                                    <% } %>
                                </td>
                            </tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            <% } %>
        </div>
    </div>

    <!-- Patients Section -->
    <div class="card mb-5" id="patients-section">
        <div class="card-header">
            <h4 class="mb-0">
                <i class="fas fa-users"></i>
                Patients List
            </h4>
        </div>
        <div class="card-body">
            <% if (patients.isEmpty()) { %>
                <div class="alert alert-info">
                    No patients registered yet.
                </div>
            <% } else { %>
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Name</th>
                                <th>Email</th>
                                <th>Phone</th>
                                <th>Created At</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                        <% for (User patient : patients) { %>
                            <tr>
                                <td><%= patient.getId() %></td>
                                <td><strong><%= patient.getName() %></strong></td>
                                <td><%= patient.getEmail() %></td>
                                <td><%= patient.getPhone() != null ? patient.getPhone() : "N/A" %></td>
                                <td><%= patient.getCreatedAt() != null ? patient.getCreatedAt() : "N/A" %></td>
                                <td>
                                    <form action="AdminManagementServlet" method="post" style="display:inline;" onsubmit="return confirm('Are you sure you want to delete this patient? This will also remove all their appointments.');">
                                        <input type="hidden" name="action" value="deletePatient">
                                        <input type="hidden" name="patientId" value="<%= patient.getId() %>">
                                        <button type="submit" class="btn btn-danger btn-sm">
                                            <i class="fas fa-trash"></i> Delete
                                        </button>
                                    </form>
                                </td>
                            </tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            <% } %>
        </div>
    </div>

    <!-- Appointments Section -->
    <div class="card mb-5" id="appointments-section">
        <div class="card-header">
            <h4 class="mb-0">
                <i class="fas fa-calendar-check"></i>
                Appointments List
            </h4>
        </div>
        <div class="card-body">
            <% if (appointments.isEmpty()) { %>
                <div class="alert alert-info">
                    No appointments booked yet.
                </div>
            <% } else { %>
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Patient Name</th>
                                <th>Doctor Name</th>
                                <th>Date</th>
                                <th>Time Slot</th>
                                <th>Reason</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                        <% for (Appointment appointment : appointments) { %>
                            <tr>
                                <td><%= appointment.getId() %></td>
                                <td><%= appointment.getPatientName() %></td>
                                <td><strong><%= appointment.getDoctorName() %></strong></td>
                                <td><%= appointment.getAppointmentDate() %></td>
                                <td><span class="badge bg-light text-dark"><i class="fas fa-clock"></i> <%= appointment.getTimeSlot() %></span></td>
                                <td><%= appointment.getReason() != null && !appointment.getReason().trim().isEmpty() ? appointment.getReason() : "N/A" %></td>
                                <td>
                                    <% 
                                        String status = appointment.getStatus();
                                        String badgeClass = "badge-scheduled";
                                        if ("completed".equals(status)) {
                                            badgeClass = "badge-completed";
                                        } else if ("cancelled".equals(status)) {
                                            badgeClass = "badge-cancelled";
                                        }
                                    %>
                                    <span class="badge <%= badgeClass %>"><%= status.substring(0, 1).toUpperCase() + status.substring(1) %></span>
                                </td>
                                <td>
                                    <% if ("scheduled".equals(status)) { %>
                                        <form action="AdminManagementServlet" method="post" style="display:inline; margin-right: 5px;">
                                            <input type="hidden" name="action" value="completeAppointment">
                                            <input type="hidden" name="appointmentId" value="<%= appointment.getId() %>">
                                            <button type="submit" class="btn btn-success btn-sm">
                                                <i class="fas fa-check-double"></i> Complete
                                            </button>
                                        </form>
                                        <form action="AdminManagementServlet" method="post" style="display:inline;" onsubmit="return confirm('Are you sure you want to cancel this appointment and release the slot?');">
                                            <input type="hidden" name="action" value="cancelAppointment">
                                            <input type="hidden" name="appointmentId" value="<%= appointment.getId() %>">
                                            <button type="submit" class="btn btn-danger btn-sm">
                                                <i class="fas fa-times"></i> Cancel
                                            </button>
                                        </form>
                                    <% } else { %>
                                        <span class="text-muted">No Actions</span>
                                    <% } %>
                                </td>
                            </tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            <% } %>
        </div>
    </div>

</div>

<!-- Add Doctor Modal -->
<div class="modal fade"
     id="addDoctorModal"
     tabindex="-1">

    <div class="modal-dialog">

        <div class="modal-content">

            <div class="modal-header">

                <h5 class="modal-title">

                    Add Doctor

                </h5>

                <button type="button"
                        class="btn-close"
                        data-bs-dismiss="modal">

                </button>

            </div>

            <form action="DoctorManagementServlet"
                  method="post">

                <div class="modal-body">

                    <input type="hidden"
                           name="action"
                           value="add">

                    <div class="mb-3">

                        <label class="form-label">
                            Doctor Name
                        </label>

                        <input type="text"
                               name="doctorName"
                               class="form-control"
                               required>

                    </div>

                    <div class="mb-3">

                        <label class="form-label">
                            Specialization
                        </label>

                        <input type="text"
                               name="specialization"
                               class="form-control"
                               required>

                    </div>

                    <div class="mb-3">

                        <label class="form-label">
                            Email
                        </label>

                        <input type="email"
                               name="email"
                               class="form-control">

                    </div>

                    <div class="mb-3">

                        <label class="form-label">
                            Phone
                        </label>

                        <input type="text"
                               name="phone"
                               class="form-control">

                    </div>

                    <div class="mb-3">

                        <label class="form-label">
                            Experience (Years)
                        </label>

                        <input type="number"
                               name="experience"
                               class="form-control">

                    </div>

                </div>

                <div class="modal-footer">

                    <button type="submit"
                            class="btn btn-success">

                        Add Doctor

                    </button>

                </div>

            </form>

        </div>

    </div>

</div>

<!-- Edit Doctor Modal -->
<div class="modal fade"
     id="editDoctorModal"
     tabindex="-1">

    <div class="modal-dialog">

        <div class="modal-content">

            <div class="modal-header">

                <h5 class="modal-title">

                    Edit Doctor Details

                </h5>

                <button type="button"
                        class="btn-close"
                        data-bs-dismiss="modal">

                </button>

            </div>

            <form action="DoctorManagementServlet"
                  method="post">

                <div class="modal-body">

                    <input type="hidden"
                           name="action"
                           value="update">

                    <input type="hidden"
                           id="editDoctorId"
                           name="doctorId">

                    <div class="mb-3">

                        <label class="form-label">
                            Doctor Name
                        </label>

                        <input type="text"
                               id="editDoctorName"
                               name="doctorName"
                               class="form-control"
                               required>

                    </div>

                    <div class="mb-3">

                        <label class="form-label">
                            Specialization
                        </label>

                        <input type="text"
                               id="editSpecialization"
                               name="specialization"
                               class="form-control"
                               required>

                    </div>

                    <div class="mb-3">

                        <label class="form-label">
                            Email
                        </label>

                        <input type="email"
                               id="editEmail"
                               name="email"
                               class="form-control">

                    </div>

                    <div class="mb-3">

                        <label class="form-label">
                            Phone
                        </label>

                        <input type="text"
                               id="editPhone"
                               name="phone"
                               class="form-control">

                    </div>

                    <div class="mb-3">

                        <label class="form-label">
                            Experience (Years)
                        </label>

                        <input type="number"
                               id="editExperience"
                               name="experience"
                               class="form-control">

                    </div>

                </div>

                <div class="modal-footer">

                    <button type="submit"
                            class="btn btn-primary">

                        Save Changes

                    </button>

                </div>

            </form>

        </div>

    </div>

</div>

<!-- Add Availability Modal -->
<div class="modal fade"
     id="addAvailabilityModal"
     tabindex="-1">

    <div class="modal-dialog">

        <div class="modal-content">

            <div class="modal-header">

                <h5 class="modal-title">

                    Add Doctor Availability Slot

                </h5>

                <button type="button"
                        class="btn-close"
                        data-bs-dismiss="modal">

                </button>

            </div>

            <form action="AvailabilityServlet"
                  method="post">

                <div class="modal-body">

                    <input type="hidden"
                           name="action"
                           value="add">

                    <div class="mb-3">

                        <label class="form-label">
                            Select Doctor
                        </label>

                        <select name="doctorId" class="form-select" required>
                            <option value="">-- Choose Doctor --</option>
                            <% for (Doctor d : doctors) { %>
                                <option value="<%= d.getId() %>"><%= d.getDoctorName() %> (<%= d.getSpecialization() %>)</option>
                            <% } %>
                        </select>

                    </div>

                    <div class="mb-3">

                        <label class="form-label">
                            Available Date
                        </label>

                        <input type="date"
                               name="availableDate"
                               class="form-control"
                               required>

                    </div>

                    <div class="mb-3">

                        <label class="form-label">
                            Time Slot
                        </label>

                        <select name="timeSlot" class="form-select" required>
                            <option value="">-- Choose Time Slot --</option>
                            <option value="09:00 AM">09:00 AM</option>
                            <option value="09:30 AM">09:30 AM</option>
                            <option value="10:00 AM">10:00 AM</option>
                            <option value="10:30 AM">10:30 AM</option>
                            <option value="11:00 AM">11:00 AM</option>
                            <option value="11:30 AM">11:30 AM</option>
                            <option value="12:00 PM">12:00 PM</option>
                            <option value="01:00 PM">01:00 PM</option>
                            <option value="01:30 PM">01:30 PM</option>
                            <option value="02:00 PM">02:00 PM</option>
                            <option value="02:30 PM">02:30 PM</option>
                            <option value="03:00 PM">03:00 PM</option>
                            <option value="03:30 PM">03:30 PM</option>
                            <option value="04:00 PM">04:00 PM</option>
                            <option value="04:30 PM">04:30 PM</option>
                            <option value="05:00 PM">05:00 PM</option>
                        </select>

                    </div>

                </div>

                <div class="modal-footer">

                    <button type="submit"
                            class="btn btn-success">

                        Add Slot

                    </button>

                </div>

            </form>

        </div>

    </div>

</div>

<script>
function filterAvailabilityTable() {
    const doctorVal = document.getElementById("filterDoctor").value;
    const dateVal = document.getElementById("filterDate").value;
    const statusVal = document.getElementById("filterStatus").value;
    
    const rows = document.querySelectorAll(".availability-row");
    rows.forEach(row => {
        const rowDoctor = row.getAttribute("data-doctor");
        const rowDate = row.getAttribute("data-date");
        const rowStatus = row.getAttribute("data-status");
        
        const matchDoctor = !doctorVal || rowDoctor === doctorVal;
        const matchDate = !dateVal || rowDate === dateVal;
        const matchStatus = !statusVal || rowStatus === statusVal;
        
        if (matchDoctor && matchDate && matchStatus) {
            row.style.display = "";
        } else {
            row.style.display = "none";
        }
    });
}

document.addEventListener("DOMContentLoaded", function() {
    // Edit Doctor button click handler
    const editButtons = document.querySelectorAll(".edit-doctor-btn");
    editButtons.forEach(button => {
        button.addEventListener("click", function() {
            const id = this.getAttribute("data-id");
            const name = this.getAttribute("data-name");
            const spec = this.getAttribute("data-specialization");
            const email = this.getAttribute("data-email");
            const phone = this.getAttribute("data-phone");
            const exp = this.getAttribute("data-experience");

            document.getElementById("editDoctorId").value = id;
            document.getElementById("editDoctorName").value = name;
            document.getElementById("editSpecialization").value = spec;
            document.getElementById("editEmail").value = email;
            document.getElementById("editPhone").value = phone;
            document.getElementById("editExperience").value = exp;
        });
    });
});
</script>

<%@ include file="includes/footer.jsp" %>
