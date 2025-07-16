@echo off
REM Quick Fix for Composer Validation Issues

echo 🔧 Quick Fix: Replacing composer.json with basic version...
echo.

cd laravel-backend

if exist composer.json (
    echo 📁 Backing up current composer.json...
    copy composer.json composer.json.backup
)

echo 📄 Using basic composer.json...
copy composer.basic.json composer.json

echo.
echo 🐳 Testing build with basic composer.json...
docker build -f Dockerfile.dev -t laravel-backend-quickfix . --progress=plain

if %errorlevel% equ 0 (
    echo ✅ SUCCESS: Quick fix worked!
    echo.
    echo 🚀 You can now run:
    echo    docker-compose -f docker-compose.dev.yml up -d
    echo.
    echo 📝 Note: Using basic Laravel dependencies only
    echo    You can restore original composer.json later from composer.json.backup
) else (
    echo ❌ Quick fix failed. Restoring original composer.json...
    if exist composer.json.backup (
        copy composer.json.backup composer.json
        del composer.json.backup
    )
    echo.
    echo 🔍 Try other methods:
    echo    1. test-build-enhanced.bat
    echo    2. debug-composer.bat
)

pause
