@echo off
REM Healthcare Appointment System - Build Script for Windows
REM This script compiles all Java files and prepares the application for deployment

echo =======================================
echo Healthcare System Build Script
echo =======================================
echo.

REM Configuration
set PROJECT_DIR=%~dp0
set SRC_DIR=%PROJECT_DIR%src
set WEB_CONTENT=%PROJECT_DIR%WebContent
set CLASSES_DIR=%WEB_CONTENT%\WEB-INF\classes
set LIB_DIR=%WEB_CONTENT%\WEB-INF\lib

REM Check if Java is installed
javac -version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Java compiler (javac) not found!
    echo Please install JDK 8 or higher.
    REM pause
    exit /b 1
)

echo Java version:
javac -version
echo.

REM Create classes directory if it doesn't exist
if not exist "%CLASSES_DIR%" (
    echo Creating classes directory...
    mkdir "%CLASSES_DIR%"
)

REM Check for required JAR files
if not exist "%LIB_DIR%\mysql-connector-java-8.0.33.jar" (
    if not exist "%LIB_DIR%\mysql-connector-j-8.0.33.jar" (
        echo WARNING: MySQL Connector JAR not found in %LIB_DIR%
        echo Please download MySQL Connector/J from:
        echo https://dev.mysql.com/downloads/connector/j/
        echo.
    )
)

if not exist "%LIB_DIR%\gson-2.10.1.jar" (
    echo WARNING: Gson JAR not found in %LIB_DIR%
    echo Please download Gson from:
    echo https://repo1.maven.org/maven2/com/google/code/gson/gson/2.10.1/gson-2.10.1.jar
    echo.
)

REM Set classpath
if defined CATALINA_HOME (
    set SERVLET_JAR=%CATALINA_HOME%\lib\servlet-api.jar
) else (
    echo WARNING: CATALINA_HOME not set. Please set it to your Tomcat installation directory.
    echo Example: set CATALINA_HOME=C:\apache-tomcat-9.0.xx
    set SERVLET_JAR=
)

set CLASSPATH=%CLASSES_DIR%;%LIB_DIR%\*;%SERVLET_JAR%

echo Compiling Java files...
echo Source directory: %SRC_DIR%
echo Output directory: %CLASSES_DIR%
echo.

REM Compile utility classes first
echo [1/5] Compiling utility classes...
javac --release 17 -d "%CLASSES_DIR%" -cp "%CLASSPATH%" "%SRC_DIR%\com\healthcare\util\*.java"
if %errorlevel% neq 0 (
    echo ERROR: Failed to compile utility classes
    REM pause
    exit /b 1
)
echo [OK] Utility classes compiled successfully

REM Compile model classes
echo [2/5] Compiling model classes...
javac --release 17 -d "%CLASSES_DIR%" -cp "%CLASSPATH%" "%SRC_DIR%\com\healthcare\model\*.java"
if %errorlevel% neq 0 (
    echo ERROR: Failed to compile model classes
    REM pause
    exit /b 1
)
echo [OK] Model classes compiled successfully

REM Compile DAO classes
echo [3/5] Compiling DAO classes...
javac --release 17 -d "%CLASSES_DIR%" -cp "%CLASSPATH%" "%SRC_DIR%\com\healthcare\dao\*.java"
if %errorlevel% neq 0 (
    echo ERROR: Failed to compile DAO classes
    REM pause
    exit /b 1
)
echo [OK] DAO classes compiled successfully

REM Compile servlet classes
echo [4/5] Compiling servlet classes...
javac --release 17 -d "%CLASSES_DIR%" -cp "%CLASSPATH%" "%SRC_DIR%\com\healthcare\servlet\*.java"
if %errorlevel% neq 0 (
    echo ERROR: Failed to compile servlet classes
    REM pause
    exit /b 1
)
echo [OK] Servlet classes compiled successfully

REM Create WAR file
echo [5/5] Creating WAR file...
cd /d "%WEB_CONTENT%"
jar -cvf "%PROJECT_DIR%healthcare-system.war" * >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Failed to create WAR file
    REM pause
    exit /b 1
)
cd /d "%PROJECT_DIR%"
echo [OK] WAR file created: healthcare-system.war

echo.
echo =======================================
echo Build completed successfully!
echo =======================================
echo.
echo Next steps:
echo 1. Ensure MySQL is running and database is created
echo 2. Update database credentials in src\com\healthcare\util\DBConnection.java
echo 3. Deploy healthcare-system.war to Tomcat webapps directory
echo 4. Start Tomcat server
echo 5. Access application at: http://localhost:8080/healthcare-system/
echo.
echo Admin credentials:
echo   Email: admin@healthcare.com
echo   Password: admin123
echo.
REM pause
