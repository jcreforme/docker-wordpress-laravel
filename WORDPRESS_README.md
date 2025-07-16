# Docker WordPress + Laravel Setup

This project integrates WordPress as a CMS with a Laravel backend API, all running in Docker containers.

## Prerequisites

- Docker Desktop installed and running
- Docker Compose (included with Docker Desktop)
- Git (to clone the repository)
- At least 4GB RAM available for Docker

## Quick Start

### Option 1: Use Startup Scripts (Easiest)

#### Windows:
```bash
# Start the stack
start.bat

# Kill processes and resolve conflicts
kill-processes.bat
```

#### Linux/Mac:
```bash
# Make scripts executable
chmod +x start.sh kill-processes.sh

# Start the stack
./start.sh

# Kill processes and resolve conflicts
./kill-processes.sh
```

### Option 2: Manual Docker Commands

### 1. Clone and Navigate to Project
```bash
git clone <your-repository-url>
cd docker-wordpress-laravel
```

### 2. Choose Your Environment

#### For Development (Recommended for local development):
```bash
docker-compose -f docker-compose.dev.yml up -d
```

#### For Production:
```bash
docker-compose up -d
```

### 3. Wait for Services to Start
```bash
# Check if all services are running
docker-compose ps

# Watch logs to see when services are ready
docker-compose logs -f
```

### 4. Access Your Applications
- **WordPress**: http://localhost:8080
- **Laravel API**: http://localhost:8000
- **phpMyAdmin**: http://localhost:8081
- **React Frontend** (if configured): http://localhost:3000

## Detailed Docker Commands

### Starting Services

```bash
# Start all services in background
docker-compose up -d

# Start specific service
docker-compose up -d wordpress

# Start with logs visible
docker-compose up

# Start development environment
docker-compose -f docker-compose.dev.yml up -d
```

### Stopping Services

```bash
# Stop all services
docker-compose down

# Stop and remove volumes (WARNING: This deletes all data!)
docker-compose down -v

# Stop specific service
docker-compose stop wordpress
```

### Viewing Logs

```bash
# View all logs
docker-compose logs

# Follow logs in real-time
docker-compose logs -f

# View logs for specific service
docker-compose logs wordpress
docker-compose logs laravel-backend

# View last 50 lines
docker-compose logs --tail=50
```

### Managing Containers

```bash
# List running containers
docker-compose ps

# Access container shell
docker-compose exec wordpress bash
docker-compose exec laravel-backend sh
docker-compose exec mysql mysql -uroot -proot_password

# Restart specific service
docker-compose restart wordpress

# Rebuild and restart
docker-compose up -d --build
```

### Data Management

```bash
# Backup WordPress data
docker-compose exec mysql mysqldump -uroot -proot_password wordpress > wordpress_backup.sql

# Backup Laravel data
docker-compose exec mysql mysqldump -uroot -proot_password laravel_app > laravel_backup.sql

# Restore database
docker-compose exec -T mysql mysql -uroot -proot_password wordpress < wordpress_backup.sql
```

### Troubleshooting Commands

```bash
# Check Docker status
docker --version
docker-compose --version

# View Docker system info
docker system df
docker system prune  # Clean up unused containers/images

# Force recreate containers
docker-compose up -d --force-recreate

# Remove all containers and start fresh
docker-compose down -v
docker-compose up -d --build
```

### Process Management & Port Issues

```bash
# === FINDING PROCESSES ===

# Windows - Find process using port
netstat -ano | findstr :8080
netstat -ano | findstr :3306

# Linux/Mac - Find process using port
netstat -tulpn | grep :8080
lsof -i :8080
ss -tulpn | grep :8080

# === KILLING PROCESSES ===

# Kill by Process ID (PID)
# Windows
taskkill /PID 1234 /F

# Linux/Mac
kill -9 1234
sudo kill -9 1234

# Kill by Process Name
# Windows
taskkill /IM "docker.exe" /F
taskkill /IM "mysqld.exe" /F
taskkill /IM "nginx.exe" /F

# Linux/Mac
killall docker
pkill -f mysql
sudo pkill -f nginx

# === KILL ALL PROCESSES ON PORT ===

# Windows - Kill everything on port 8080
for /f "tokens=5" %a in ('netstat -aon ^| find ":8080"') do taskkill /f /pid %a

# Linux/Mac - Kill everything on port 8080
sudo kill -9 $(lsof -t -i:8080)
sudo fuser -k 8080/tcp

# === DOCKER SPECIFIC ===

# Stop all Docker containers
docker stop $(docker ps -aq)

# Kill all Docker containers forcefully
docker kill $(docker ps -aq)

# Remove all stopped containers
docker container prune -f

# Emergency Docker restart
# Windows
net stop docker
net start docker

# Linux
sudo systemctl stop docker
sudo systemctl start docker

# === COMMON PORT CONFLICTS ===

# Check common ports used by this stack
netstat -ano | findstr :80      # Nginx
netstat -ano | findstr :3000    # React
netstat -ano | findstr :8000    # Laravel
netstat -ano | findstr :8080    # WordPress
netstat -ano | findstr :3306    # MySQL
netstat -ano | findstr :6379    # Redis
```

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

#### Docker Issues:

1. **Containers won't start**
   ```bash
   # Check if Docker is running
   docker info
   
   # Check for port conflicts
   docker-compose ps
   netstat -tulpn | grep :8080  # Check if port is in use
   
   # Try rebuilding
   docker-compose down
   docker-compose up -d --build
   ```

2. **"Port already in use" errors**
   ```bash
   # Find what's using the port (Windows)
   netstat -ano | findstr :8080
   
   # Find what's using the port (Linux/Mac)
   netstat -tulpn | grep :8080
   lsof -i :8080
   
   # Kill process by PID (Windows)
   taskkill /PID <PID_NUMBER> /F
   
   # Kill process by PID (Linux/Mac)
   kill -9 <PID_NUMBER>
   
   # Kill all Docker processes
   docker stop $(docker ps -aq)
   docker rm $(docker ps -aq)
   
   # Alternative: Change ports in docker-compose.yml
   # Example: Change "8080:80" to "8081:80"
   ```

3. **Kill specific processes by name**
   ```bash
   # Windows - Kill by process name
   taskkill /IM "docker.exe" /F
   taskkill /IM "Docker Desktop.exe" /F
   
   # Linux/Mac - Kill by process name
   killall docker
   pkill -f docker
   
   # Kill processes using specific ports
   # Windows
   for /f "tokens=5" %a in ('netstat -aon ^| find ":8080"') do taskkill /f /pid %a
   
   # Linux/Mac
   sudo kill -9 $(lsof -t -i:8080)
   ```

4. **Emergency Docker cleanup**
   ```bash
   # Stop all Docker containers
   docker stop $(docker ps -aq)
   
   # Remove all containers
   docker rm $(docker ps -aq)
   
   # Remove all images
   docker rmi $(docker images -q)
   
   # Nuclear option - remove everything
   docker system prune -a --volumes
   
   # Restart Docker Desktop (Windows)
   taskkill /IM "Docker Desktop.exe" /F
   # Then restart Docker Desktop from Start menu
   
   # Restart Docker service (Linux)
   sudo systemctl restart docker
   ```

3. **Database connection failed**
   ```bash
   # Wait for MySQL to fully start
   docker-compose logs mysql
   
   # Check if database exists
   docker-compose exec mysql mysql -uroot -proot_password -e "SHOW DATABASES;"
   ```

4. **Out of disk space**
   ```bash
   # Clean up Docker
   docker system prune -a
   docker volume prune
   
   # Check disk usage
   docker system df
   ```

#### Application Issues:

1. **WordPress installation page shows**
   - Check that MySQL is running and accessible
   - Verify database environment variables

2. **CORS issues between Laravel and WordPress**
   - The custom theme and plugin include CORS headers
   - Check that both services are on the same Docker network

3. **Can't access WordPress admin**
   - Make sure you completed the WordPress setup at http://localhost:8080
   - Check that the database connection is working

4. **Laravel returns 500 errors**
   ```bash
   # Check Laravel logs
   docker-compose exec laravel-backend cat storage/logs/laravel.log
   
   # Check if .env file exists
   docker-compose exec laravel-backend ls -la .env
   
   # Regenerate application key
   docker-compose exec laravel-backend php artisan key:generate
   ```

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
