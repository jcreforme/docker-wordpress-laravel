#!/bin/bash

# Test Docker Build Script

echo "🔨 Testing Docker Build for Laravel Backend..."
echo ""

cd laravel-backend

echo "📁 Current directory contents:"
ls -la
echo ""

echo "🐳 Building Docker image..."
docker build -f Dockerfile.dev -t laravel-backend-test .

if [ $? -eq 0 ]; then
    echo "✅ Docker build successful!"
    echo ""
    echo "🧪 You can now run:"
    echo "   docker-compose -f docker-compose.dev.yml up -d"
else
    echo "❌ Docker build failed!"
    echo ""
    echo "🔍 Check the error messages above for details."
fi
