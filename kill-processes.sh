#!/bin/bash

# Process Killer Script for WordPress + Laravel Docker Stack

echo "🔧 Docker Process Management Tool"
echo "================================="
echo ""

# Function to check if running on Windows (Git Bash/WSL)
is_windows() {
    [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || -n "$WSL_DISTRO_NAME" ]]
}

# Function to find processes on port
find_port_process() {
    local port=$1
    echo "🔍 Checking what's using port $port..."
    
    if is_windows; then
        netstat -ano | findstr ":$port"
    else
        lsof -i :$port 2>/dev/null || netstat -tulpn | grep ":$port"
    fi
}

# Function to kill process by PID
kill_process() {
    local pid=$1
    echo "💀 Killing process $pid..."
    
    if is_windows; then
        taskkill /PID $pid /F
    else
        kill -9 $pid 2>/dev/null || sudo kill -9 $pid
    fi
}

# Function to kill processes on port
kill_port_processes() {
    local port=$1
    echo "💀 Killing all processes on port $port..."
    
    if is_windows; then
        for /f "tokens=5" %a in ('netstat -aon ^| find ":$port"') do taskkill /f /pid %a
    else
        sudo fuser -k $port/tcp 2>/dev/null || sudo kill -9 $(lsof -t -i:$port) 2>/dev/null
    fi
    
    echo "✅ Port $port should now be free"
}

# Main menu
echo "What would you like to do?"
echo ""
echo "1) Check ports used by Docker stack (80, 3000, 8000, 8080, 3306, 6379)"
echo "2) Kill processes on specific port"
echo "3) Stop all Docker containers"
echo "4) Kill all Docker processes"
echo "5) Emergency Docker cleanup"
echo "6) Restart Docker service"
echo "7) Check and kill common conflicting processes"
echo "8) Exit"
echo ""

read -p "Enter your choice (1-8): " choice

case $choice in
    1)
        echo ""
        echo "🔍 Checking Docker stack ports..."
        echo ""
        echo "Port 80 (Nginx):"
        find_port_process 80
        echo ""
        echo "Port 3000 (React):"
        find_port_process 3000
        echo ""
        echo "Port 8000 (Laravel):"
        find_port_process 8000
        echo ""
        echo "Port 8080 (WordPress):"
        find_port_process 8080
        echo ""
        echo "Port 3306 (MySQL):"
        find_port_process 3306
        echo ""
        echo "Port 6379 (Redis):"
        find_port_process 6379
        ;;
        
    2)
        echo ""
        read -p "Enter port number: " port
        find_port_process $port
        echo ""
        read -p "Kill all processes on port $port? (y/n): " confirm
        if [[ $confirm =~ ^[Yy]$ ]]; then
            kill_port_processes $port
        fi
        ;;
        
    3)
        echo ""
        echo "🛑 Stopping all Docker containers..."
        docker stop $(docker ps -aq) 2>/dev/null
        echo "✅ All Docker containers stopped"
        ;;
        
    4)
        echo ""
        echo "💀 Killing all Docker processes..."
        docker kill $(docker ps -aq) 2>/dev/null
        echo "✅ All Docker processes killed"
        ;;
        
    5)
        echo ""
        echo "🧹 Emergency Docker cleanup..."
        echo "This will remove ALL Docker containers, images, and volumes!"
        read -p "Are you sure? (y/n): " confirm
        if [[ $confirm =~ ^[Yy]$ ]]; then
            docker stop $(docker ps -aq) 2>/dev/null
            docker rm $(docker ps -aq) 2>/dev/null
            docker rmi $(docker images -q) 2>/dev/null
            docker system prune -a --volumes -f
            echo "✅ Docker cleanup complete"
        fi
        ;;
        
    6)
        echo ""
        echo "🔄 Restarting Docker service..."
        if is_windows; then
            echo "Please restart Docker Desktop manually from the system tray"
        else
            sudo systemctl restart docker
            echo "✅ Docker service restarted"
        fi
        ;;
        
    7)
        echo ""
        echo "🔍 Checking for common conflicting processes..."
        
        # Check for Apache/IIS on port 80
        echo "Checking port 80 (Apache/IIS conflicts):"
        find_port_process 80
        
        # Check for MySQL on port 3306
        echo ""
        echo "Checking port 3306 (MySQL conflicts):"
        find_port_process 3306
        
        # Check for existing WordPress/XAMPP
        echo ""
        echo "Checking port 8080 (WordPress/XAMPP conflicts):"
        find_port_process 8080
        
        echo ""
        read -p "Kill all conflicting processes? (y/n): " confirm
        if [[ $confirm =~ ^[Yy]$ ]]; then
            kill_port_processes 80
            kill_port_processes 3306
            kill_port_processes 8080
            
            # Kill common server processes
            if is_windows; then
                taskkill /IM "httpd.exe" /F 2>/dev/null
                taskkill /IM "mysqld.exe" /F 2>/dev/null
                taskkill /IM "nginx.exe" /F 2>/dev/null
            else
                pkill -f apache2 2>/dev/null
                pkill -f httpd 2>/dev/null
                pkill -f mysql 2>/dev/null
                pkill -f nginx 2>/dev/null
            fi
            
            echo "✅ Conflicting processes cleaned up"
        fi
        ;;
        
    8)
        echo "👋 Goodbye!"
        exit 0
        ;;
        
    *)
        echo "❌ Invalid choice"
        exit 1
        ;;
esac

echo ""
echo "🎉 Task completed!"
echo ""
read -p "Press Enter to exit..."
