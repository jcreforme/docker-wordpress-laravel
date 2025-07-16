@echo off
REM WordPress + Laravel Docker Startup Script for Windows

echo 🐳 Starting WordPress + Laravel Docker Stack...
echo.

REM Check if Docker is running
docker info >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker is not running. Please start Docker Desktop first.
    pause
    exit /b 1
)

REM Check if docker-compose is available
docker-compose --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ docker-compose is not installed.
    pause
    exit /b 1
)

echo ✅ Docker is running
echo.

REM Ask user which environment to start
echo Which environment would you like to start?
echo 1) Development (recommended for local development)
echo 2) Production
echo.
set /p choice=Enter your choice (1 or 2): 

if "%choice%"=="1" (
    echo 🚀 Starting development environment...
    docker-compose -f docker-compose.dev.yml down >nul 2>&1
    docker-compose -f docker-compose.dev.yml up -d
    set COMPOSE_FILE=docker-compose.dev.yml
) else if "%choice%"=="2" (
    echo 🚀 Starting production environment...
    docker-compose down >nul 2>&1
    docker-compose up -d
    set COMPOSE_FILE=docker-compose.yml
) else (
    echo ❌ Invalid choice. Exiting.
    pause
    exit /b 1
)

echo.
echo ⏳ Waiting for services to start...
timeout /t 10 /nobreak >nul

REM Check service status
echo.
echo 📊 Service Status:
if "%COMPOSE_FILE%"=="docker-compose.dev.yml" (
    docker-compose -f docker-compose.dev.yml ps
) else (
    docker-compose ps
)

echo.
echo 🎉 Services are starting up! Please wait a moment for all services to be ready.
echo.
echo 📱 Access your applications:
echo    WordPress: http://localhost:8080
echo    Laravel API: http://localhost:8000
echo    phpMyAdmin: http://localhost:8081
echo    Frontend (if configured): http://localhost:3000
echo.
echo 📝 First time setup:
echo    1. Visit http://localhost:8080 to complete WordPress installation
echo    2. Activate the custom theme and Laravel Integration plugin
echo.
echo 🔧 Useful commands:
echo    View logs: docker-compose logs -f
echo    Stop services: docker-compose down
echo    Access containers: docker-compose exec [service] bash
echo.

REM Ask if user wants to view logs
set /p view_logs=Would you like to view the logs? (y/n): 

if /i "%view_logs%"=="y" (
    echo.
    echo 📋 Showing logs (Press Ctrl+C to exit):
    if "%COMPOSE_FILE%"=="docker-compose.dev.yml" (
        docker-compose -f docker-compose.dev.yml logs -f
    ) else (
        docker-compose logs -f
    )
)

pause
