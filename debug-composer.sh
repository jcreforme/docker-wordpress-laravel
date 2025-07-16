#!/bin/bash

# Composer Debug Script

echo "🔍 Debugging Composer Issues..."
echo ""

cd laravel-backend

echo "📋 Checking composer.json validity..."
if [ -f composer.json ]; then
    echo "✅ composer.json exists"
    echo "Validating composer.json..."
    docker run --rm -v $(pwd):/app composer:latest validate /app/composer.json
else
    echo "❌ composer.json not found!"
fi

echo ""
echo "🌐 Testing internet connectivity..."
docker run --rm alpine:latest ping -c 3 packagist.org

echo ""
echo "🐳 Testing composer install in isolation..."
docker run --rm -v $(pwd):/app -w /app composer:latest install --dry-run

echo ""
echo "💾 Checking available disk space..."
df -h

echo ""
echo "🧠 Checking available memory..."
free -h

echo ""
echo "📦 Available Docker images..."
docker images | head -10

echo ""
echo "🔧 Suggested solutions:"
echo "1. If network test failed: Check firewall/proxy settings"
echo "2. If validation failed: Use composer.simple.json"
echo "3. If disk space low: Clean up with 'docker system prune -a'"
echo "4. If memory low: Increase Docker memory allocation"
echo "5. Try building with: docker build --no-cache"
