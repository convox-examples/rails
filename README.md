# Rails Example for Convox

A modern Rails 7.1 application ready to deploy on Convox Cloud Machines or your own Convox Rack.

This example demonstrates a production-ready Rails application with PostgreSQL database, Redis caching, health checks, and a real-time dashboard. It showcases Rails best practices while being optimized for Convox deployment.

## Features

- **Rails 7.1** with modern best practices
- **PostgreSQL** database with migrations and seeds
- **User Management** CRUD interface
- **API Endpoints** with JSON responses
- **Health Monitoring** with dedicated endpoints
- **Dashboard** showing real-time stats
- **Docker Optimized** for fast builds and small images
- **Cloud Machine Ready** with proper CPU/memory settings

## Deploy to Convox Cloud

1. **Create a Cloud Machine** at [console.convox.com](https://console.convox.com)

2. **Create the app**:
```bash
convox cloud apps create rails-app -i your-machine-name
```

3. **Set the secret key**:
```bash
convox cloud env set SECRET_KEY_BASE=$(openssl rand -hex 64) -a rails-app -i your-machine-name
```

4. **Deploy the app**:
```bash
convox cloud deploy -a rails-app -i your-machine-name
```

5. **Run database setup**:
```bash
# Run migrations
convox cloud run web "bundle exec rails db:migrate" -a rails-app -i your-machine-name

# Seed the database (optional)
convox cloud run web "bundle exec rails db:seed" -a rails-app -i your-machine-name
```

6. **View your app**:
```bash
convox cloud services -a rails-app -i your-machine-name
```

Visit the URL to see your application running!

## Deploy to Convox Rack

1. **Create the app**:
```bash
convox apps create rails-app
```

2. **Set the secret key**:
```bash
convox env set SECRET_KEY_BASE=$(openssl rand -hex 64) -a rails-app
```

3. **Deploy the app**:
```bash
convox deploy -a rails-app
```

4. **Run database setup**:
```bash
# Run migrations
convox run web "bundle exec rails db:migrate" -a rails-app

# Seed the database (optional)
convox run web "bundle exec rails db:seed" -a rails-app
```

5. **View your app**:
```bash
convox services -a rails-app
```

## Application Endpoints

- `GET /` - Dashboard with real-time statistics
- `GET /health` - Health check endpoint
- `GET /api/status` - System status JSON
- `GET /users` - User management interface
- `GET /api/users` - Users API endpoint
- `GET /api/stats` - Application statistics

## Test the API

```bash
# Check health
curl https://your-app-url/health

# Get system status
curl https://your-app-url/api/status

# Get users list
curl https://your-app-url/api/users
```

## Local Development

1. **Clone the repository**:
```bash
git clone https://github.com/convox-examples/rails
cd rails
```

2. **Start with Convox** (no local Ruby/bundler needed!):
```bash
convox start
```

The app will be available at http://localhost:3000

> **Note**: This example follows containerized best practices - all dependencies are installed inside Docker containers. You don't need Ruby, Node, or any dependencies installed locally.

## Scaling

### Convox Cloud
```bash
# Scale horizontally
convox cloud scale web --count 3 -a rails-app -i your-machine-name

# Scale vertically
convox cloud scale web --cpu 500 --memory 1024 -a rails-app -i your-machine-name
```

### Convox Rack
```bash
# Scale horizontally
convox scale web --count 3 -a rails-app

# Scale vertically
convox scale web --cpu 500 --memory 1024 -a rails-app
```

## Common Commands

### View logs
```bash
# Cloud
convox cloud logs -a rails-app -i your-machine-name

# Rack
convox logs -a rails-app
```

### Rails console
```bash
# Cloud
convox cloud run web "bundle exec rails console" -a rails-app -i your-machine-name

# Rack
convox run web "bundle exec rails console" -a rails-app
```

### Database console
```bash
# Cloud
convox cloud run web "bundle exec rails dbconsole" -a rails-app -i your-machine-name

# Rack
convox run web "bundle exec rails dbconsole" -a rails-app
```

## Environment Variables

| Variable | Description | Required |
|----------|-------------|----------|
| `SECRET_KEY_BASE` | Rails secret key | Yes |
| `DATABASE_URL` | PostgreSQL connection (auto-set by Convox) | Auto |
| `RAILS_ENV` | Rails environment | Set to `production` |
| `RAILS_MAX_THREADS` | Max threads per worker | Optional (default: 5) |

## Architecture Notes

### SSL/TLS Handling
Convox handles SSL termination at the load balancer level. The application receives plain HTTP traffic on port 3000. This is standard practice for containerized applications:
- Load Balancer: Handles HTTPS (port 443) with Let's Encrypt certificates
- Application: Receives HTTP (port 3000) from the load balancer
- Configuration: `config.force_ssl = false` with `config.assume_ssl = true`

### Host Authorization
For simplicity, this example sets `ALLOW_ALL_HOSTS=true` to handle:
- Health checks from internal Kubernetes IPs
- Requests forwarded through the Convox load balancer
- Various Convox subdomain patterns

For production applications, you should restrict this to your specific domains.

## Troubleshooting

### SSL/HTTPS Errors
If you see "Invalid HTTP format" or SSL-related errors, ensure:
- The app is configured to receive HTTP (not HTTPS) on port 3000
- `config.force_ssl = false` in production.rb
- SSL is handled by the Convox load balancer, not the Rails app

### Host Authorization (Rails 7+)
If you see "Blocked hosts" errors:
- This example uses `ALLOW_ALL_HOSTS=true` for simplicity
- For production, configure specific allowed hosts in production.rb

### Assets not loading
The app is configured with `RAILS_SERVE_STATIC_FILES=true` for simplicity. For production, consider using a CDN.

### Memory issues
```bash
# Increase memory allocation
convox scale web --memory 1024 -a rails-app
```

## What's Included

- Modern Rails 7.1 setup
- PostgreSQL database with sample data
- User management system
- RESTful API endpoints
- Health monitoring
- Optimized Docker build
- Production-ready configuration
- Cloud Machine compatible settings (CPU: 250)