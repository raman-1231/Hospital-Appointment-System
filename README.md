# Smart Healthcare Appointment Management System

## 🏥 Overview

A comprehensive web-based healthcare appointment management system built with **JSP, Servlet, MySQL, HTML, CSS, Bootstrap, JavaScript, and JDBC**. This system enables patients to book appointments with doctors while providing administrators with tools to manage doctors, appointments, and availability schedules.

---

## ✨ Features

### Patient Features
- ✅ User registration and secure login
- ✅ Browse available doctors by specialization
- ✅ Book appointments with real-time availability checking
- ✅ View appointment history and status
- ✅ Responsive and user-friendly dashboard

### Admin Features
- ✅ Secure admin login
- ✅ Comprehensive dashboard with statistics
- ✅ Doctor management (Add, View, Delete)
- ✅ View all appointments across the system
- ✅ Manage doctor availability slots
- ✅ Real-time availability tracking

### Technical Features
- ✅ Modern, responsive UI with Bootstrap 5
- ✅ Interactive medical theme design
- ✅ Client-side form validation with JavaScript
- ✅ Server-side validation and security
- ✅ Session management for secure authentication
- ✅ AJAX-based real-time slot availability
- ✅ Database transaction support
- ✅ Clean MVC architecture

---

## 🛠️ Technology Stack

### Backend
- **Java Servlets** - Business logic and request handling
- **JDBC** - Database connectivity
- **JSP** - Dynamic page generation
- **MySQL** - Relational database

### Frontend
- **HTML5 & CSS3** - Structure and styling
- **Bootstrap 5** - Responsive design framework
- **JavaScript** - Client-side interactivity
- **Font Awesome** - Icons
- **Google Fonts** - Typography

### Server
- **Apache Tomcat 9.0+** - Java web application server

### Additional Libraries
- **Gson** - JSON serialization/deserialization for AJAX responses

---

## 📋 Prerequisites

Before you begin, ensure you have the following installed:

1. **Java Development Kit (JDK) 8 or higher**
   - Download: https://www.oracle.com/java/technologies/downloads/
   - Verify: `java -version`

2. **Apache Tomcat 9.0 or higher**
   - Download: https://tomcat.apache.org/download-90.cgi
   - Extract to a directory (e.g., `C:\apache-tomcat-9.0.xx` or `/opt/tomcat`)

3. **MySQL 8.0 or higher**
   - Download: https://dev.mysql.com/downloads/mysql/
   - Verify: `mysql --version`

4. **MySQL JDBC Driver (Connector/J)**
   - Download: https://dev.mysql.com/downloads/connector/j/
   - Version: 8.0.33 or higher

5. **Gson Library**
   - Download: https://repo1.maven.org/maven2/com/google/code/gson/gson/2.10.1/gson-2.10.1.jar

---

## 🚀 Installation and Setup

### Step 1: Database Setup

1. **Start MySQL Server**
   ```bash
   # On Windows (run as administrator)
   net start MySQL80
   
   # On Linux/Mac
   sudo systemctl start mysql
   # or
   sudo service mysql start
   ```

2. **Login to MySQL**
   ```bash
   mysql -u root -p
   ```

3. **Create Database and Tables**
   ```bash
   # Navigate to the database folder
   cd /path/to/healthcare-system/database
   
   # Execute the SQL script
   mysql -u root -p < schema.sql
   ```
   
   Or manually in MySQL:
   ```sql
   source /path/to/healthcare-system/database/schema.sql;
   ```

4. **Verify Database Creation**
   ```sql
   USE healthcare_db;
   SHOW TABLES;
   SELECT * FROM admins;
   SELECT * FROM doctors;
   ```

### Step 2: Configure Database Connection

1. Open `src/com/healthcare/util/DBConnection.java`

2. Update the database credentials:
   ```java
   private static final String DB_URL = "jdbc:mysql://localhost:3306/healthcare_db";
   private static final String DB_USER = "root";          // Your MySQL username
   private static final String DB_PASSWORD = "your_password";  // Your MySQL password
   ```

### Step 3: Setup Libraries

1. **Download Required JAR Files:**
   - MySQL Connector/J: `mysql-connector-java-8.0.33.jar`
   - Gson: `gson-2.10.1.jar`

2. **Place JAR Files:**
   ```
   Copy both JAR files to:
   healthcare-system/WebContent/WEB-INF/lib/
   ```

### Step 4: Compile Java Files

1. **Set CLASSPATH:**
   ```bash
   # On Windows
   set CLASSPATH=.;WebContent\WEB-INF\lib\mysql-connector-java-8.0.33.jar;WebContent\WEB-INF\lib\gson-2.10.1.jar;C:\path\to\tomcat\lib\servlet-api.jar
   
   # On Linux/Mac
   export CLASSPATH=.:WebContent/WEB-INF/lib/mysql-connector-java-8.0.33.jar:WebContent/WEB-INF/lib/gson-2.10.1.jar:/path/to/tomcat/lib/servlet-api.jar
   ```

2. **Compile Java Source Files:**
   ```bash
   # Navigate to the project root
   cd healthcare-system
   
   # Create classes directory
   mkdir -p WebContent/WEB-INF/classes
   
   # Compile all Java files
   javac -d WebContent/WEB-INF/classes -cp "$CLASSPATH" src/com/healthcare/util/*.java
   javac -d WebContent/WEB-INF/classes -cp "$CLASSPATH" src/com/healthcare/model/*.java
   javac -d WebContent/WEB-INF/classes -cp "$CLASSPATH" src/com/healthcare/dao/*.java
   javac -d WebContent/WEB-INF/classes -cp "$CLASSPATH" src/com/healthcare/servlet/*.java
   ```

### Step 5: Deploy to Tomcat

#### Option A: Direct WAR Deployment

1. **Create WAR file:**
   ```bash
   cd WebContent
   jar -cvf healthcare-system.war *
   ```

2. **Deploy to Tomcat:**
   ```bash
   # Copy WAR to Tomcat webapps directory
   cp healthcare-system.war /path/to/tomcat/webapps/
   ```

#### Option B: Manual Deployment

1. **Copy entire project to Tomcat:**
   ```bash
   # Copy WebContent folder to Tomcat webapps
   cp -r healthcare-system/WebContent /path/to/tomcat/webapps/healthcare-system
   ```

### Step 6: Start Tomcat Server

1. **Start Tomcat:**
   ```bash
   # On Windows
   C:\path\to\tomcat\bin\startup.bat
   
   # On Linux/Mac
   /path/to/tomcat/bin/startup.sh
   ```

2. **Verify Tomcat is Running:**
   - Open browser: `http://localhost:8080`
   - You should see Tomcat welcome page

### Step 7: Access the Application

1. **Open your web browser**

2. **Navigate to:**
   ```
   http://localhost:8080/healthcare-system/
   ```
   or if deployed as WAR:
   ```
   http://localhost:8080/healthcare-system/
   ```

---

## 🔐 Default Login Credentials

### Admin Access
- **Email:** admin@healthcare.com
- **Password:** admin123

### Patient Access
- Register a new patient account through the registration page
- Or use the database to create test patient accounts

---

## 📁 Project Structure

```
healthcare-system/
│
├── src/
│   └── com/healthcare/
│       ├── dao/                      # Data Access Objects
│       │   ├── UserDAO.java
│       │   ├── AdminDAO.java
│       │   ├── DoctorDAO.java
│       │   ├── AppointmentDAO.java
│       │   └── AvailabilityDAO.java
│       │
│       ├── model/                    # Java Beans/Model Classes
│       │   ├── User.java
│       │   ├── Doctor.java
│       │   ├── Appointment.java
│       │   └── DoctorAvailability.java
│       │
│       ├── servlet/                  # Servlet Controllers
│       │   ├── RegisterServlet.java
│       │   ├── LoginServlet.java
│       │   ├── LogoutServlet.java
│       │   ├── BookAppointmentServlet.java
│       │   ├── DoctorManagementServlet.java
│       │   ├── AvailabilityServlet.java
│       │   ├── GetAvailableSlotsServlet.java
│       │   └── GetDoctorAvailabilityServlet.java
│       │
│       └── util/                     # Utility Classes
│           └── DBConnection.java
│
├── WebContent/
│   ├── WEB-INF/
│   │   ├── web.xml                  # Deployment Descriptor
│   │   ├── classes/                 # Compiled Java classes
│   │   └── lib/                     # JAR libraries
│   │       ├── mysql-connector-java-8.0.33.jar
│   │       └── gson-2.10.1.jar
│   │
│   ├── css/
│   │   └── style.css               # Custom CSS styles
│   │
│   ├── js/
│   │   └── script.js               # JavaScript functions
│   │
│   ├── images/                     # Image assets
│   │
│   ├── includes/
│   │   ├── header.jsp              # Common header
│   │   └── footer.jsp              # Common footer
│   │
│   ├── index.jsp                   # Landing page
│   ├── login.jsp                   # Login page
│   ├── register.jsp                # Registration page
│   ├── dashboard.jsp               # Patient dashboard
│   ├── bookAppointment.jsp         # Book appointment page
│   ├── viewAppointments.jsp        # View appointments page
│   ├── admin.jsp                   # Admin dashboard
│   └── error.jsp                   # Error page
│
├── database/
│   └── schema.sql                  # Database schema and seed data
│
└── README.md                       # This file
```

---

## 🗄️ Database Schema

### Tables

1. **users** - Patient information
   - id, name, email, password, phone, created_at

2. **doctors** - Doctor information
   - id, doctor_name, specialization, email, phone, experience_years, status, created_at

3. **appointments** - Appointment bookings
   - id, user_id, doctor_id, appointment_date, time_slot, status, reason, created_at

4. **doctor_availability** - Doctor availability slots
   - id, doctor_id, available_date, time_slot, is_booked

5. **admins** - Admin accounts
   - id, email, password, name, created_at

---

## 🔧 Troubleshooting

### Issue: Database Connection Failed

**Solution:**
1. Verify MySQL is running: `mysql -u root -p`
2. Check database credentials in `DBConnection.java`
3. Ensure MySQL JDBC driver is in `WEB-INF/lib/`
4. Check MySQL port (default: 3306)

### Issue: 404 Error - Page Not Found

**Solution:**
1. Verify Tomcat is running: `http://localhost:8080`
2. Check deployment path: `/tomcat/webapps/healthcare-system/`
3. Ensure all JSP files are in WebContent directory
4. Check web.xml configuration

### Issue: Servlet Not Found

**Solution:**
1. Verify Java files are compiled to `WEB-INF/classes/`
2. Check package structure matches directory structure
3. Verify servlet annotations (`@WebServlet`)
4. Restart Tomcat server

### Issue: JSON/AJAX Not Working

**Solution:**
1. Ensure Gson library is in `WEB-INF/lib/`
2. Check browser console for JavaScript errors
3. Verify servlet paths in AJAX calls
4. Enable CORS if needed

### Issue: CSS/JS Not Loading

**Solution:**
1. Check file paths in JSP pages
2. Ensure files are in correct directories (css/, js/)
3. Clear browser cache
4. Verify Bootstrap and Font Awesome CDN links

---

## 🎨 UI Features

- **Modern Medical Theme** - Calming blue and white color scheme
- **Responsive Design** - Works on desktop, tablet, and mobile
- **Interactive Elements** - Hover effects, smooth transitions
- **User-Friendly** - Intuitive navigation and clear CTAs
- **Accessibility** - Semantic HTML and ARIA labels

---

## 🔒 Security Features

- Session-based authentication
- Role-based access control (Admin/Patient)
- Input validation (client & server side)
- SQL injection prevention (PreparedStatements)
- Password validation requirements
- Session timeout configuration

---

## 📝 Usage Guide

### For Patients:

1. **Register Account**
   - Click "Register" from homepage
   - Fill in personal details
   - Create secure password

2. **Login**
   - Enter email and password
   - Select "Patient" as user type

3. **Book Appointment**
   - Navigate to "Book Appointment"
   - Select doctor from dropdown
   - Choose available date
   - Select time slot
   - Provide reason for visit
   - Submit booking

4. **View Appointments**
   - Check "My Appointments" page
   - View all scheduled appointments
   - See appointment status

### For Admins:

1. **Login**
   - Use admin credentials
   - Select "Admin" as user type

2. **Manage Doctors**
   - Add new doctors with specializations
   - View all doctors
   - Delete inactive doctors

3. **Manage Availability**
   - Add availability slots for doctors
   - View doctor schedules
   - Remove unavailable slots

4. **View Appointments**
   - Monitor all system appointments
   - Check patient-doctor bookings
   - Track appointment statuses

---

## 🚀 Future Enhancements

- [ ] Email notifications for appointments
- [ ] SMS reminders
- [ ] Appointment cancellation by patients
- [ ] Doctor profiles with photos
- [ ] Online payment integration
- [ ] Medical records management
- [ ] Video consultation integration
- [ ] Appointment rescheduling
- [ ] Patient medical history
- [ ] Prescription management

---

## 🤝 Contributing

This is a student project. For improvements or suggestions, please contact the development team.

---

## 📄 License

This project is developed for educational purposes.

---

## 👨‍💻 Developer Notes

### Important Files:
- **DBConnection.java** - Update database credentials here
- **web.xml** - Servlet configuration
- **schema.sql** - Database structure and seed data

### Key Technologies:
- **MVC Pattern** - Model-View-Controller architecture
- **DAO Pattern** - Data Access Object for database operations
- **Servlet API** - Java EE web components
- **JDBC** - Java Database Connectivity

---

## 📞 Support

For issues or questions:
1. Check the troubleshooting section
2. Review Tomcat logs: `/tomcat/logs/catalina.out`
3. Check MySQL error logs
4. Verify all prerequisites are installed

---

## ✅ Testing Checklist

- [ ] Database connection successful
- [ ] Patient registration working
- [ ] Patient login working
- [ ] Admin login working
- [ ] Doctor list displaying
- [ ] Appointment booking functional
- [ ] Time slots loading dynamically
- [ ] Appointments visible in patient dashboard
- [ ] Admin can add doctors
- [ ] Admin can manage availability
- [ ] All appointments visible to admin
- [ ] Logout working for both roles
- [ ] Responsive design on mobile
- [ ] Form validations working
- [ ] Error messages displaying

---

**Thank you for using the Healthcare Appointment Management System!** 🏥

*Built with ❤️ using JSP, Servlet, MySQL, and Bootstrap*