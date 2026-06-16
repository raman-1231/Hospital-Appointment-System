# Quick Start Guide
# Healthcare Appointment Management System

## 🚀 Quick Setup (5 Minutes)

### Prerequisites Checklist
- [ ] JDK 8+ installed
- [ ] MySQL 8.0+ installed and running
- [ ] Apache Tomcat 9.0+ installed
- [ ] MySQL Connector/J JAR downloaded
- [ ] Gson JAR downloaded

---

## Step-by-Step Setup

### 1. Database Setup (2 minutes)

```bash
# Login to MySQL
mysql -u root -p

# Create database and import schema
source /path/to/healthcare-system/database/schema.sql

# Verify
USE healthcare_db;
SHOW TABLES;
```

### 2. Configure Database Connection (1 minute)

Edit `src/com/healthcare/util/DBConnection.java`:

```java
private static final String DB_USER = "root";           // Your MySQL username
private static final String DB_PASSWORD = "your_pass";   // Your MySQL password
```

### 3. Add JAR Files (1 minute)

Place these files in `WebContent/WEB-INF/lib/`:
- mysql-connector-java-8.0.33.jar
- gson-2.10.1.jar

### 4. Build Project (1 minute)

**On Linux/Mac:**
```bash
chmod +x build.sh
./build.sh
```

**On Windows:**
```cmd
build.bat
```

### 5. Deploy to Tomcat (30 seconds)

```bash
# Copy WAR file to Tomcat
cp healthcare-system.war /path/to/tomcat/webapps/

# Start Tomcat
/path/to/tomcat/bin/startup.sh     # Linux/Mac
C:\tomcat\bin\startup.bat          # Windows
```

### 6. Access Application

Open browser: **http://localhost:8080/healthcare-system/**

---

## 🔑 Login Credentials

### Admin Login
```
Email: admin@healthcare.com
Password: admin123
```

### Patient
Register a new account through the registration page

---

## ⚡ Troubleshooting Quick Fixes

### Problem: Can't connect to database
```bash
# Check if MySQL is running
sudo systemctl status mysql        # Linux
net start MySQL80                  # Windows

# Test connection
mysql -u root -p -h localhost -P 3306
```

### Problem: 404 Error
```bash
# Check Tomcat is running
curl http://localhost:8080

# Verify deployment
ls /path/to/tomcat/webapps/healthcare-system/
```

### Problem: Compilation errors
```bash
# Ensure CATALINA_HOME is set
export CATALINA_HOME=/path/to/tomcat    # Linux/Mac
set CATALINA_HOME=C:\tomcat             # Windows

# Verify JDK version
javac -version    # Should be 1.8 or higher
```

### Problem: Classes not found
```bash
# Verify classes were compiled
ls WebContent/WEB-INF/classes/com/healthcare/servlet/

# Rebuild
./build.sh    # or build.bat on Windows
```

---

## 📋 Project Structure Quick Reference

```
healthcare-system/
├── src/                           ← Java source code
├── WebContent/                    ← Web files (JSP, CSS, JS)
├── database/schema.sql            → Run this to create database
├── build.sh / build.bat           → Run this to compile
└── README.md                      → Full documentation
```

---

## 🎯 Testing Checklist

After deployment, test these:

1. [ ] Homepage loads (http://localhost:8080/healthcare-system/)
2. [ ] Patient registration works
3. [ ] Patient login works
4. [ ] Admin login works (admin@healthcare.com / admin123)
5. [ ] Doctors list displays
6. [ ] Book appointment works
7. [ ] View appointments works

---

## 📞 Need Help?

1. Check full README.md for detailed documentation
2. Review Tomcat logs: `/tomcat/logs/catalina.out`
3. Check MySQL error logs
4. Verify all JAR files are in place

---

## 🔗 Download Links

**MySQL Connector/J:**
https://dev.mysql.com/downloads/connector/j/

**Gson Library:**
https://repo1.maven.org/maven2/com/google/code/gson/gson/2.10.1/gson-2.10.1.jar

**Apache Tomcat:**
https://tomcat.apache.org/download-90.cgi

**Java JDK:**
https://www.oracle.com/java/technologies/downloads/

---

**That's it! You should now have a running Healthcare Appointment System.** 🎉

For detailed documentation, see README.md