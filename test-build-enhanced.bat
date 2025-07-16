@echo off
REM Enhanced Test Docker Build Script for Windows

echo 🔨 Testing Docker Build for Laravel Backend...
echo.

cd laravel-backend

echo 📁 Current directory contents:
dir
echo.

echo 🐳 Method 1: Enhanced Composer Build...
docker build -f Dockerfile.dev -t laravel-backend-test . --progress=plain

if %errorlevel% equ 0 (
    echo ✅ SUCCESS: Enhanced composer build worked!
    goto success
)

echo 🐳 Method 2: Skip Validation Build...
docker build -f Dockerfile.skipvalidation -t laravel-backend-test-skipval . --progress=plain

if %errorlevel% equ 0 (
    echo ✅ SUCCESS: Skip validation build worked!
    echo � Update docker-compose.dev.yml: dockerfile: Dockerfile.skipvalidation
    goto success
)

echo.
echo �🐳 Method 3: Alternative Extensions Build...
docker build -f Dockerfile.dev.alt -t laravel-backend-test-alt . --progress=plain

if %errorlevel% equ 0 (
    echo ✅ SUCCESS: Alternative build worked!
    echo 📝 Update docker-compose.dev.yml: dockerfile: Dockerfile.dev.alt
    goto success
)

echo.
echo 🐳 Method 4: Minimal Build...
docker build -f Dockerfile.minimal -t laravel-backend-test-minimal . --progress=plain

if %errorlevel% equ 0 (
    echo ✅ SUCCESS: Minimal build worked!
    echo 📝 Update docker-compose.dev.yml: dockerfile: Dockerfile.minimal
    goto success
)

echo.
echo 🐳 Method 5: No-Composer Build (Basic functionality)...
docker build -f Dockerfile.nocomposer -t laravel-backend-test-nocomposer . --progress=plain

if %errorlevel% equ 0 (
    echo ✅ SUCCESS: No-composer build worked!
    echo 📝 Update docker-compose.dev.yml: dockerfile: Dockerfile.nocomposer
    echo 🚨 NOTE: This has basic functionality only
    goto success
)

echo.
echo ❌ ALL BUILD METHODS FAILED!
echo.
echo 🆘 TROUBLESHOOTING STEPS:
echo 1. Restart Docker Desktop completely
echo 2. Run: docker system prune -a --volumes
echo 3. Check Docker has 4GB+ memory allocated
echo 4. Verify internet connection works
echo 5. Try building on a different network
echo 6. Check BUILD_TROUBLESHOOTING.md for detailed help
echo.
echo 💡 You can also try:
echo    docker build -f Dockerfile.dev . --no-cache --progress=plain
echo.
goto end

:success
echo.
echo 🎉 BUILD SUCCESSFUL!
echo.
echo 🚀 Next steps:
echo 1. Run: docker-compose -f docker-compose.dev.yml up -d
echo 2. Wait for services to start (about 30 seconds)
echo 3. Visit: http://localhost:8080 (WordPress)
echo 4. Visit: http://localhost:8000 (Laravel API)
echo.

:end
pause
