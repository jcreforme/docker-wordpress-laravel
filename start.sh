#!/bin/bash

# WordPress + Laravel Docker Startup Script

echo "🐳 Starting WordPress + Laravel Docker Stack..."
echo ""

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker Desktop first."
    exit 1
fi

# Check if docker-compose is available
if ! command -v docker-compose &> /dev/null; then
    echo "❌ docker-compose is not installed."
    exit 1
fi

echo "✅ Docker is running"
echo ""

# Check if Laravel backend image exists
if ! docker images | grep -q "laravel-backend"; then
    echo "⚠️  Laravel backend image not found."
    echo "Would you like to test build it first? (recommended)"
    echo "1) Yes, test build now"
    echo "2) No, continue anyway"
    echo ""
    read -p "Enter your choice (1 or 2): " build_choice
    
    if [ "$build_choice" = "1" ]; then
        echo "🔨 Testing Docker build..."
        cd laravel-backend
        if docker build -f Dockerfile.dev -t laravel-backend-test . --quiet; then
            echo "✅ Build test successful!"
            cd ..
        else
            echo "❌ Build test failed!"
            echo "Please run: ./test-build-enhanced.sh (or .bat on Windows)"
            echo "Or try: ./quickfix-composer.sh"
            exit 1
        fi
    fi
fi

# Ask user which environment to start
echo "Which environment would you like to start?"
echo "1) Development (recommended for local development)"
echo "2) Production"
echo ""
read -p "Enter your choice (1 or 2): " choice

case $choice in
    1)
        echo "🚀 Starting development environment..."
        docker-compose -f docker-compose.dev.yml down 2>/dev/null
        docker-compose -f docker-compose.dev.yml up -d
        COMPOSE_FILE="docker-compose.dev.yml"
        ;;
    2)
        echo "🚀 Starting production environment..."
        docker-compose down 2>/dev/null
        docker-compose up -d
        COMPOSE_FILE="docker-compose.yml"
        ;;
    *)
        echo "❌ Invalid choice. Exiting."
        exit 1
        ;;
esac

echo ""
echo "⏳ Waiting for services to start..."
sleep 10

# Check service status
echo ""
echo "📊 Service Status:"
if [ "$COMPOSE_FILE" = "docker-compose.dev.yml" ]; then
    docker-compose -f docker-compose.dev.yml ps
else
    docker-compose ps
fi

echo ""
echo "🎉 Services are starting up! Please wait a moment for all services to be ready."
echo ""
echo "📱 Access your applications:"
echo "   WordPress: http://localhost:8080"
echo "   Laravel API: http://localhost:8000"
echo "   phpMyAdmin: http://localhost:8081"
echo "   Frontend (if configured): http://localhost:3000"
echo ""
echo "📝 First time setup:"
echo "   1. Visit http://localhost:8080 to complete WordPress installation"
echo "   2. Activate the custom theme and Laravel Integration plugin"
echo ""
echo "🔧 Useful commands:"
echo "   View logs: docker-compose logs -f"
echo "   Stop services: docker-compose down"
echo "   Access containers: docker-compose exec [service] bash"
echo ""

# Ask if user wants to view logs
read -p "Would you like to view the logs? (y/n): " view_logs

if [[ $view_logs =~ ^[Yy]$ ]]; then
    echo ""
    echo "📋 Showing logs (Press Ctrl+C to exit):"
    if [ "$COMPOSE_FILE" = "docker-compose.dev.yml" ]; then
        docker-compose -f docker-compose.dev.yml logs -f
    else
        docker-compose logs -f
    fi
fi
