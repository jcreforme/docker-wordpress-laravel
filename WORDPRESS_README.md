# Docker WordPress + Laravel Setup

This project integrates WordPress as a CMS with a Laravel backend API, all running in Docker containers.

## Services

- **WordPress**: CMS running on port 8080
- **Laravel Backend**: API server running on port 8000  
- **MySQL**: Database server for both WordPress and Laravel
- **Redis**: Caching service
- **Nginx**: Reverse proxy (when enabled)
- **phpMyAdmin**: Database management on port 8081

## WordPress Setup

### 1. Directory Structure

```
wordpress/
├── themes/
│   └── custom-theme/         # Custom WordPress theme
│       ├── style.css
│       ├── index.php
│       ├── header.php
│       ├── footer.php
│       └── functions.php
└── plugins/
    └── laravel-integration/  # Custom plugin for Laravel integration
        └── laravel-integration.php
```

### 2. Custom WordPress Features

#### Custom Theme
- Located in `wordpress/themes/custom-theme/`
- Includes responsive design
- CORS headers for Laravel integration
- Custom REST API endpoints

#### Laravel Integration Plugin
- Custom REST API endpoints at `/wp-json/laravel/v1/`
- Endpoints include:
  - `/posts` - Get posts formatted for Laravel
  - `/categories` - Get categories
  - `/users` - Get users

### 3. WordPress API Endpoints

The custom plugin provides these endpoints for Laravel integration:

```
GET /wp-json/laravel/v1/posts?page=1&per_page=10
GET /wp-json/laravel/v1/categories
GET /wp-json/laravel/v1/users
```

### 4. Running the Stack

#### Development Mode
```bash
docker-compose -f docker-compose.dev.yml up -d
```

#### Production Mode
```bash
docker-compose up -d
```

### 5. First Time Setup

1. Start the containers
2. Visit http://localhost:8080 to complete WordPress installation
3. Install the custom theme and plugin:
   - Go to Appearance > Themes and activate "Custom Laravel WordPress Theme"
   - Go to Plugins and activate "Laravel Integration"

### 6. Database Configuration

- WordPress uses the `wordpress` database
- Laravel uses the `laravel_app` database
- Both share the same MySQL instance
- Database credentials are configured in docker-compose files

### 7. Laravel WordPress Integration

In your Laravel application, you can fetch WordPress content using:

```php
// Get WordPress posts
$response = Http::get('http://wordpress/wp-json/laravel/v1/posts');
$posts = $response->json();

// Get WordPress categories
$response = Http::get('http://wordpress/wp-json/laravel/v1/categories');
$categories = $response->json();
```

### 8. Environment Variables

WordPress-related environment variables in Laravel:

```env
WORDPRESS_DB_HOST=mysql
WORDPRESS_DB_DATABASE=wordpress
WORDPRESS_DB_USERNAME=root
WORDPRESS_DB_PASSWORD=root_password
WORDPRESS_API_URL=http://wordpress/wp-json/wp/v2
```

### 9. Nginx Routing (when enabled)

- `/` - React frontend
- `/api/` - Laravel backend
- `/wp/` - WordPress
- `/wp-admin/` - WordPress admin
- `/wp-json/` - WordPress API

### 10. Development Features

The development setup includes:
- Xdebug for PHP debugging
- Hot reloading for frontend changes
- Volume mounts for live code editing
- Debug logging enabled

### 11. Troubleshooting

#### Common Issues:

1. **WordPress installation page shows**
   - Check that MySQL is running and accessible
   - Verify database environment variables

2. **CORS issues between Laravel and WordPress**
   - The custom theme and plugin include CORS headers
   - Check that both services are on the same Docker network

3. **Can't access WordPress admin**
   - Make sure you completed the WordPress setup at http://localhost:8080
   - Check that the database connection is working

#### Useful Commands:

```bash
# View logs
docker-compose logs wordpress
docker-compose logs laravel-backend

# Access containers
docker-compose exec wordpress bash
docker-compose exec laravel-backend sh

# Reset WordPress data
docker-compose down -v
docker-compose up -d
```

### 12. Customization

- Modify `wordpress/themes/custom-theme/` for theme changes
- Edit `wordpress/plugins/laravel-integration/` for API customization
- Update `docker/nginx/` configurations for routing changes
