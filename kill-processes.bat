@echo off
REM Process Killer Script for WordPress + Laravel Docker Stack (Windows)

echo 🔧 Docker Process Management Tool
echo =================================
echo.

:menu
echo What would you like to do?
echo.
echo 1) Check ports used by Docker stack (80, 3000, 8000, 8080, 3306, 6379)
echo 2) Kill processes on specific port
echo 3) Stop all Docker containers
echo 4) Kill all Docker processes
echo 5) Emergency Docker cleanup
echo 6) Restart Docker Desktop
echo 7) Check and kill common conflicting processes
echo 8) Exit
echo.

set /p choice=Enter your choice (1-8): 

if "%choice%"=="1" goto check_ports
if "%choice%"=="2" goto kill_port
if "%choice%"=="3" goto stop_docker
if "%choice%"=="4" goto kill_docker
if "%choice%"=="5" goto cleanup_docker
if "%choice%"=="6" goto restart_docker
if "%choice%"=="7" goto kill_conflicts
if "%choice%"=="8" goto exit_script
echo ❌ Invalid choice
goto menu

:check_ports
echo.
echo 🔍 Checking Docker stack ports...
echo.
echo Port 80 (Nginx):
netstat -ano | findstr :80
echo.
echo Port 3000 (React):
netstat -ano | findstr :3000
echo.
echo Port 8000 (Laravel):
netstat -ano | findstr :8000
echo.
echo Port 8080 (WordPress):
netstat -ano | findstr :8080
echo.
echo Port 3306 (MySQL):
netstat -ano | findstr :3306
echo.
echo Port 6379 (Redis):
netstat -ano | findstr :6379
goto end

:kill_port
echo.
set /p port=Enter port number: 
echo.
echo 🔍 Processes using port %port%:
netstat -ano | findstr :%port%
echo.
set /p confirm=Kill all processes on port %port%? (y/n): 
if /i "%confirm%"=="y" (
    echo 💀 Killing processes on port %port%...
    for /f "tokens=5" %%a in ('netstat -aon ^| find ":%port%"') do taskkill /f /pid %%a >nul 2>&1
    echo ✅ Port %port% should now be free
)
goto end

:stop_docker
echo.
echo 🛑 Stopping all Docker containers...
docker stop $(docker ps -aq) >nul 2>&1
echo ✅ All Docker containers stopped
goto end

:kill_docker
echo.
echo 💀 Killing all Docker processes...
docker kill $(docker ps -aq) >nul 2>&1
echo ✅ All Docker processes killed
goto end

:cleanup_docker
echo.
echo 🧹 Emergency Docker cleanup...
echo This will remove ALL Docker containers, images, and volumes!
set /p confirm=Are you sure? (y/n): 
if /i "%confirm%"=="y" (
    docker stop $(docker ps -aq) >nul 2>&1
    docker rm $(docker ps -aq) >nul 2>&1
    docker rmi $(docker images -q) >nul 2>&1
    docker system prune -a --volumes -f >nul 2>&1
    echo ✅ Docker cleanup complete
)
goto end

:restart_docker
echo.
echo 🔄 Restarting Docker Desktop...
taskkill /IM "Docker Desktop.exe" /F >nul 2>&1
timeout /t 3 /nobreak >nul
echo Please start Docker Desktop manually from the Start menu
echo ✅ Docker Desktop has been stopped
goto end

:kill_conflicts
echo.
echo 🔍 Checking for common conflicting processes...
echo.
echo Port 80 (Apache/IIS conflicts):
netstat -ano | findstr :80
echo.
echo Port 3306 (MySQL conflicts):
netstat -ano | findstr :3306
echo.
echo Port 8080 (WordPress/XAMPP conflicts):
netstat -ano | findstr :8080
echo.
set /p confirm=Kill all conflicting processes? (y/n): 
if /i "%confirm%"=="y" (
    echo 💀 Killing conflicting processes...
    
    REM Kill processes on common ports
    for /f "tokens=5" %%a in ('netstat -aon ^| find ":80"') do taskkill /f /pid %%a >nul 2>&1
    for /f "tokens=5" %%a in ('netstat -aon ^| find ":3306"') do taskkill /f /pid %%a >nul 2>&1
    for /f "tokens=5" %%a in ('netstat -aon ^| find ":8080"') do taskkill /f /pid %%a >nul 2>&1
    
    REM Kill common server processes
    taskkill /IM "httpd.exe" /F >nul 2>&1
    taskkill /IM "mysqld.exe" /F >nul 2>&1
    taskkill /IM "nginx.exe" /F >nul 2>&1
    taskkill /IM "apache.exe" /F >nul 2>&1
    
    echo ✅ Conflicting processes cleaned up
)
goto end

:end
echo.
echo 🎉 Task completed!
echo.
pause
goto menu

:exit_script
echo 👋 Goodbye!
exit /b 0
