-- Create WordPress database
CREATE DATABASE IF NOT EXISTS wordpress CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Grant privileges for WordPress database
GRANT ALL PRIVILEGES ON wordpress.* TO 'root'@'%';

-- Create a separate user for WordPress if needed
-- CREATE USER IF NOT EXISTS 'wp_user'@'%' IDENTIFIED BY 'wp_password';
-- GRANT ALL PRIVILEGES ON wordpress.* TO 'wp_user'@'%';

-- Ensure Laravel database exists
CREATE DATABASE IF NOT EXISTS laravel_app CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Grant privileges for Laravel database
GRANT ALL PRIVILEGES ON laravel_app.* TO 'laravel_user'@'%';

FLUSH PRIVILEGES;
