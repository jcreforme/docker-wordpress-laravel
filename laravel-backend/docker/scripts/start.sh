#!/bin/sh

# Laravel Docker Startup Script

echo "Starting Laravel application..."

# Wait for database to be ready
echo "Waiting for database connection..."
while ! nc -z mysql 3306; do
  echo "Waiting for MySQL..."
  sleep 1
done
echo "Database is ready!"

# Check if .env file exists, if not copy from .env.example
if [ ! -f /var/www/html/.env ]; then
    echo "Creating .env file from .env.example..."
    cp /var/www/html/.env.example /var/www/html/.env
    
    # Update database configuration
    sed -i 's/DB_HOST=127.0.0.1/DB_HOST=mysql/' /var/www/html/.env
    sed -i 's/DB_DATABASE=laravel/DB_DATABASE=laravel_app/' /var/www/html/.env
    sed -i 's/DB_USERNAME=root/DB_USERNAME=root/' /var/www/html/.env
    sed -i 's/DB_PASSWORD=/DB_PASSWORD=root_password/' /var/www/html/.env
fi

# Generate application key if not set
echo "Generating application key..."
php artisan key:generate --no-interaction --force

# Clear and cache configuration
echo "Setting up Laravel cache..."
php artisan config:clear
php artisan cache:clear
php artisan route:clear
php artisan view:clear

# Run migrations
echo "Running database migrations..."
php artisan migrate --force

# Cache configurations for better performance
echo "Caching configurations..."
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Set proper permissions
echo "Setting permissions..."
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html/storage
chmod -R 755 /var/www/html/bootstrap/cache

echo "Laravel setup complete! Starting services..."

# Start supervisor
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
