# Laravel Backend Dockerfile
FROM php:8.1-fpm-alpine

# Install system dependencies
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
    supervisor

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install zip \
    && docker-php-ext-install intl \
    && docker-php-ext-install soap \
    && docker-php-ext-install mysqli

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy composer files
COPY composer.json composer.lock* ./

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader --no-scripts

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
