# Docker Build Troubleshooting Guide

## Error: Composer Install Failed

If you're getting errors during composer installation like:
```
ERROR [laravel-backend-dev stage-0 8/12] RUN composer install --optimize-autoloader
```

### Common Composer Issues & Solutions:

### 1. **Network/Internet Issues**
```bash
# Test internet connectivity in Docker
docker run --rm alpine:latest ping -c 3 packagist.org

# If this fails, check your network/firewall settings
```

### 2. **Memory Issues**
Composer requires significant memory:
```bash
# Increase Docker memory to 4GB+ in Docker Desktop settings
# Or build with memory limit
docker build --memory=4g -f Dockerfile.dev -t test .
```

### 3. **Composer Cache Issues**
```bash
# Clear composer cache before building
docker build --no-cache -f Dockerfile.dev -t test .

# Or in Dockerfile, we now include:
# RUN composer clear-cache
```

### 4. **Package Conflicts**
Try the simplified composer.json:
```bash
# Copy composer.simple.json to composer.json
cp composer.simple.json composer.json
docker build -f Dockerfile.dev -t test .
```

### 5. **PHP Extension Dependencies**
Some packages require specific PHP extensions:
```dockerfile
# Make sure all extensions are installed before composer
RUN docker-php-ext-install pdo_mysql mbstring zip
RUN composer install
```

## Error: PHP Extension Installation Failed

If you're getting errors during PHP extension installation like:
```
ERROR [laravel-backend-dev stage-0 3/11] RUN docker-php-ext-install pdo_mysql mbstring...
```

### Try These Solutions (In Order):

### 1. **Use the Fixed Dockerfile.dev**
The updated `Dockerfile.dev` includes all necessary build dependencies:
```bash
docker build -f Dockerfile.dev -t laravel-backend-test .
```

### 2. **Use Alternative Dockerfile**
If the standard build fails, try the alternative approach:
```bash
docker build -f Dockerfile.dev.alt -t laravel-backend-test .
```

### 3. **Use Minimal Dockerfile for Testing**
For quick testing with basic functionality:
```bash
docker build -f Dockerfile.minimal -t laravel-backend-test .
```

### 4. **Clean Docker Cache**
Sometimes old cached layers cause issues:
```bash
# Clean everything
docker system prune -a --volumes

# Or just build cache
docker builder prune -a

# Then rebuild
docker build -f Dockerfile.dev -t laravel-backend-test . --no-cache
```

### 5. **Check Docker Resources**
Make sure Docker has enough resources:
- **Memory**: At least 4GB allocated to Docker
- **Disk Space**: At least 10GB free
- **CPU**: At least 2 cores allocated

### 6. **Platform-Specific Build**
For M1 Macs or ARM processors:
```bash
docker build --platform linux/amd64 -f Dockerfile.dev -t laravel-backend-test .
```

### 7. **Manual Extension Installation**
If specific extensions fail, try this Dockerfile approach:
```dockerfile
# Install extensions one by one
RUN docker-php-ext-install pdo_mysql || true
RUN docker-php-ext-install mbstring || true
RUN docker-php-ext-install zip || true
```

### 8. **Check Internet Connection**
Extension compilation requires downloading packages:
```bash
# Test if Docker can access internet
docker run --rm alpine:latest ping -c 3 google.com
```

### 9. **Use Pre-built PHP Images**
As a last resort, use a pre-built image with extensions:
```dockerfile
FROM webdevops/php-nginx:8.1-alpine
# Skip extension installation entirely
```

## Common PHP Extension Issues:

### **GD Extension Issues:**
```dockerfile
# Add these dependencies
RUN apk add --no-cache \
    libpng-dev \
    libjpeg-turbo-dev \
    freetype-dev

# Configure before installing
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install gd
```

### **Intl Extension Issues:**
```dockerfile
# Add ICU development libraries
RUN apk add --no-cache icu-dev
RUN docker-php-ext-install intl
```

### **Zip Extension Issues:**
```dockerfile
# Add libzip development libraries
RUN apk add --no-cache libzip-dev
RUN docker-php-ext-install zip
```

## Quick Test Commands:

```bash
# Test standard build
docker build -f Dockerfile.dev -t test-standard .

# Test alternative build
docker build -f Dockerfile.dev.alt -t test-alt .

# Test minimal build
docker build -f Dockerfile.minimal -t test-minimal .

# Test with no cache
docker build -f Dockerfile.dev -t test-nocache . --no-cache

# Test with platform specification
docker build --platform linux/amd64 -f Dockerfile.dev -t test-platform .
```

## If All Else Fails:

1. **Use the minimal Dockerfile** for basic functionality
2. **Install extensions later** using docker exec after container is running
3. **Use a different base image** like `webdevops/php-nginx:8.1-alpine`
4. **Report the issue** with full error logs for further assistance

## Getting Help:

If you're still having issues, run this command and share the output:
```bash
docker build -f Dockerfile.dev -t debug-build . --progress=plain --no-cache 2>&1 | tee build-log.txt
```

This will create a detailed build log in `build-log.txt` that can help diagnose the specific issue.
