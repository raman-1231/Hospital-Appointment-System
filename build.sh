#!/bin/bash

# Healthcare Appointment System - Build Script
# This script compiles all Java files and prepares the application for deployment

echo "======================================="
echo "Healthcare System Build Script"
echo "======================================="
echo ""

# Configuration
PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC_DIR="$PROJECT_DIR/src"
WEB_CONTENT="$PROJECT_DIR/WebContent"
CLASSES_DIR="$WEB_CONTENT/WEB-INF/classes"
LIB_DIR="$WEB_CONTENT/WEB-INF/lib"

# Check if Java is installed
if ! command -v javac &> /dev/null; then
    echo "ERROR: Java compiler (javac) not found!"
    echo "Please install JDK 8 or higher."
    exit 1
fi

echo "Java version:"
javac -version
echo ""

# Create classes directory if it doesn't exist
if [ ! -d "$CLASSES_DIR" ]; then
    echo "Creating classes directory..."
    mkdir -p "$CLASSES_DIR"
fi

# Check for required JAR files
if [ ! -f "$LIB_DIR/mysql-connector-java-8.0.33.jar" ] && [ ! -f "$LIB_DIR/mysql-connector-j-8.0.33.jar" ]; then
    echo "WARNING: MySQL Connector JAR not found in $LIB_DIR"
    echo "Please download MySQL Connector/J from:"
    echo "https://dev.mysql.com/downloads/connector/j/"
    echo ""
fi

if [ ! -f "$LIB_DIR/gson-2.10.1.jar" ]; then
    echo "WARNING: Gson JAR not found in $LIB_DIR"
    echo "Please download Gson from:"
    echo "https://repo1.maven.org/maven2/com/google/code/gson/gson/2.10.1/gson-2.10.1.jar"
    echo ""
fi

# Set classpath
if [ -n "$CATALINA_HOME" ]; then
    SERVLET_JAR="$CATALINA_HOME/lib/servlet-api.jar"
else
    echo "WARNING: CATALINA_HOME not set. Please set it to your Tomcat installation directory."
    echo "Example: export CATALINA_HOME=/path/to/tomcat"
    SERVLET_JAR=""
fi

CLASSPATH="$CLASSES_DIR:$LIB_DIR/*:$SERVLET_JAR"

echo "Compiling Java files..."
echo "Source directory: $SRC_DIR"
echo "Output directory: $CLASSES_DIR"
echo ""

# Compile utility classes first
echo "[1/5] Compiling utility classes..."
javac -d "$CLASSES_DIR" -cp "$CLASSPATH" "$SRC_DIR/com/healthcare/util/"*.java
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to compile utility classes"
    exit 1
fi
echo "✓ Utility classes compiled successfully"

# Compile model classes
echo "[2/5] Compiling model classes..."
javac -d "$CLASSES_DIR" -cp "$CLASSPATH" "$SRC_DIR/com/healthcare/model/"*.java
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to compile model classes"
    exit 1
fi
echo "✓ Model classes compiled successfully"

# Compile DAO classes
echo "[3/5] Compiling DAO classes..."
javac -d "$CLASSES_DIR" -cp "$CLASSPATH" "$SRC_DIR/com/healthcare/dao/"*.java
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to compile DAO classes"
    exit 1
fi
echo "✓ DAO classes compiled successfully"

# Compile servlet classes
echo "[4/5] Compiling servlet classes..."
javac -d "$CLASSES_DIR" -cp "$CLASSPATH" "$SRC_DIR/com/healthcare/servlet/"*.java
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to compile servlet classes"
    exit 1
fi
echo "✓ Servlet classes compiled successfully"

# Create WAR file
echo "[5/5] Creating WAR file..."
cd "$WEB_CONTENT"
jar -cvf "$PROJECT_DIR/healthcare-system.war" * > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to create WAR file"
    exit 1
fi
cd "$PROJECT_DIR"
echo "✓ WAR file created: healthcare-system.war"

echo ""
echo "======================================="
echo "Build completed successfully!"
echo "======================================="
echo ""
echo "Next steps:"
echo "1. Ensure MySQL is running and database is created"
echo "2. Update database credentials in src/com/healthcare/util/DBConnection.java"
echo "3. Deploy healthcare-system.war to Tomcat webapps directory"
echo "4. Start Tomcat server"
echo "5. Access application at: http://localhost:8080/healthcare-system/"
echo ""
echo "Admin credentials:"
echo "  Email: admin@healthcare.com"
echo "  Password: admin123"
echo ""