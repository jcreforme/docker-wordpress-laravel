@echo off
REM Test Docker Build Script for Windows

echo 🔨 Testing Docker Build for Laravel Backend...
echo.

cd laravel-backend

echo 📁 Current directory contents:
dir
echo.

echo 🐳 Building Docker image (Method 1 - Standard)...
docker build -f Dockerfile.dev -t laravel-backend-test .

if %errorlevel% equ 0 (
    echo ✅ Docker build successful with standard method!
    echo.
    echo 🧪 You can now run:
    echo    docker-compose -f docker-compose.dev.yml up -d
) else (
    echo ❌ Standard build failed! Trying alternative method...
    echo.
    
    echo 🐳 Building Docker image (Method 2 - Alternative)...
    docker build -f Dockerfile.dev.alt -t laravel-backend-test-alt .
    
    if %errorlevel% equ 0 (
        echo ✅ Docker build successful with alternative method!
        echo.
        echo � To use the alternative build, update docker-compose.dev.yml:
        echo    Change 'dockerfile: Dockerfile.dev' to 'dockerfile: Dockerfile.dev.alt'
        echo.
        echo 🧪 Then run:
        echo    docker-compose -f docker-compose.dev.yml up -d
    ) else (
        echo ❌ Both build methods failed!
        echo.
        echo 🔍 Common solutions:
        echo    1. Make sure Docker Desktop is running and updated
        echo    2. Try: docker system prune -a
        echo    3. Check internet connection for package downloads
        echo    4. Increase Docker memory limit in Docker Desktop settings
    )
)

pause
