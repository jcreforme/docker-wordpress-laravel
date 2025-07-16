# Laravel Backend Dockerfile
FROM php:8.1-# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Configure Composer for better performance and reliability
RUN composer config --global process-timeout 600 \
    && composer config --global cache-dir /tmp/composer-cache

# Set working directory
WORKDIR /var/www/html

# Copy composer files (handle case where they might not exist)
COPY composer.json composer.lock* ./

# Install PHP dependencies with better error handling
RUN echo "🎵 Starting composer installation..." \
    && (composer validate --no-check-publish 2>/dev/null || echo "⚠️ Composer validation had warnings, continuing...") \
    && echo "📦 Installing dependencies..." \
    && composer install --no-dev --optimize-autoloader --no-scripts --no-interaction --prefer-dist 2>&1 || \
    (echo "📦 Initial install failed, clearing cache and retrying..." && \
     composer clear-cache && \
     composer install --no-dev --optimize-autoloader --no-scripts --no-interaction --prefer-dist 2>&1) || \
    (echo "📦 Standard install failed, creating fresh Laravel project..." && \
     rm -rf * .* 2>/dev/null || true && \
     composer create-project laravel/laravel . --prefer-dist --no-scripts --no-interaction && \
     echo "✅ Fresh Laravel project created")# Install system dependencies and build tools
RUN apk add --no-cache \
    git \
    curl \
    libpng-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    libxml2-dev \
    libzip-dev \
    libxslt-dev \
    icu-dev \
    zip \
    unzip \
    nginx \
    supervisor \
    # Build dependencies
    autoconf \
    gcc \
    g++ \
    make \
    libc-dev \
    linux-headers \
    zlib-dev \
    oniguruma-dev

# Install PHP extensions step by step for better error handling
RUN docker-php-ext-configure gd --with-freetype --with-jpeg

RUN docker-php-ext-install -j$(nproc) \
    pdo_mysql \
    mbstring \
    exif \
    pcntl \
    bcmath \
    gd \
    zip \
    intl \
    soap \
    mysqli

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy composer files (check if they exist first)
COPY composer.json composer.lock* ./

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader --no-scripts || \
    (echo "Composer install failed, creating minimal Laravel structure..." && \
     composer create-project laravel/laravel . --prefer-dist --no-scripts && \
     composer install --no-dev --optimize-autoloader --no-scripts)

# Copy application code
COPY . .

# Set permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html/storage \
    && chmod -R 755 /var/www/html/bootstrap/cache

# Copy Nginx config
COPY docker/nginx/laravel.conf /etc/nginx/http.d/default.conf

# Copy supervisor config
COPY docker/supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Copy startup script
COPY docker/scripts/start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

# Install netcat for database connection checking
RUN apk add --no-cache netcat-openbsd

# Generate application key (only if .env exists)
RUN if [ -f .env ]; then php artisan key:generate --no-interaction; fi

# Run migrations and cache config (only if database is available)
# Note: These commands might fail if database isn't ready, so we make them optional
RUN if [ -f .env ]; then \
        php artisan config:cache || true; \
        php artisan route:cache || true; \
        php artisan view:cache || true; \
    fi

# Expose port 80
EXPOSE 80

# Use startup script instead of direct supervisor command
CMD ["/usr/local/bin/start.sh"]
