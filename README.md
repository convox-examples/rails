# Rails Example for Convox

A modern Rails 7.1 application ready to deploy on Convox.

This example demonstrates how to deploy a production-ready Rails application on Convox with PostgreSQL, Redis caching, background jobs, and auto-scaling. It includes a user management system, API endpoints, background job processing, and a real-time dashboard showcasing Rails best practices.

Deploy to Convox Cloud for a fully-managed platform experience, or to your own Convox Rack for complete control over your infrastructure. Either way, you'll get automatic SSL, load balancing, and zero-downtime deployments out of the box.

## Deploy to Convox Cloud

1. **Create a Cloud Machine** at [console.convox.com](https://console.convox.com)

2. **Create the app**:
```bash
convox cloud apps create rails-app -i your-machine-name
```

3. **Set environment variables**:
```bash
# Generate a secret key using openssl
convox cloud env set SECRET_KEY_BASE=$(openssl rand -hex 64) -a rails-app -i your-machine-name

# Or if you have the app built locally with Docker:
# docker build -t rails-app .
# convox cloud env set SECRET_KEY_BASE=$(docker run --rm rails-app bundle exec rails secret) -a rails-app -i your-machine-name
```

4. **Deploy the app**:
```bash
convox cloud deploy -a rails-app -i your-machine-name
```

5. **Run database migrations**:
```bash
convox cloud run web "bundle exec rails db:migrate" -a rails-app -i your-machine-name
```

6. **Seed the database** (optional):
```bash
convox cloud run web "bundle exec rails db:seed" -a rails-app -i your-machine-name
```

7. **View your app**:
```bash
convox cloud services -a rails-app -i your-machine-name
```

Visit your URL to see the application!

## Deploy to Convox Rack

1. **Create the app**:
```bash
convox apps create rails-app
```

2. **Set environment variables**:
```bash
# Generate a secret key using openssl
convox env set SECRET_KEY_BASE=$(openssl rand -hex 64) -a rails-app

# Or if you have the app built locally with Docker:
# docker build -t rails-app .
# convox env set SECRET_KEY_BASE=$(docker run --rm rails-app bundle exec rails secret) -a rails-app
```

3. **Deploy the app**:
```bash
convox deploy -a rails-app
```

4. **Run database migrations**:
```bash
convox run web "bundle exec rails db:migrate" -a rails-app
```

5. **Seed the database** (optional):
```bash
convox run web "bundle exec rails db:seed" -a rails-app
```

6. **View your app**:
```bash
convox services -a rails-app
```

Visit your URL to see the application!

## Features

- **User Management** - Full CRUD operations with authentication
- **Background Jobs** - Asynchronous processing with Solid Queue
- **Redis Caching** - Performance optimization with Solid Cache
- **Real-time Dashboard** - Live stats and metrics
- **RESTful API** - JSON API endpoints with CORS support
- **Health Checks** - Production-ready health and status endpoints
- **Auto-scaling** - CPU and memory-based scaling
- **Asset Pipeline** - Optimized with Rails 7.1 and Tailwind CSS

## Application Endpoints

- `GET /` - Dashboard with real-time statistics
- `GET /health` - Health check endpoint
- `GET /api/status` - System status JSON
- `GET /users` - User management interface
- `GET /api/users` - Users API endpoint
- `GET /api/stats` - Application statistics API
- `GET /sidekiq` - Background job monitoring (if configured)

## Test the API

```bash
# Check health status
curl https://your-app-url/health

# Get system status
curl https://your-app-url/api/status

# Get user list (API)
curl https://your-app-url/api/users

# Get application stats
curl https://your-app-url/api/stats
```

## Local Development

1. **Install dependencies**:
```bash
bundle install
yarn install
```

2. **Setup database**:
```bash
rails db:create db:migrate db:seed
```

3. **Start the server**:
```bash
rails server
```

4. **Run tests**:
```bash
rails test
```

## Background Jobs

The application uses Solid Queue for background job processing. Jobs automatically scale based on load.

To manually run a job console:
```bash
# Cloud
convox cloud run worker "bundle exec rails console" -a rails-app -i your-machine-name

# Rack
convox run worker "bundle exec rails console" -a rails-app
```

## Scaling

### Convox Cloud
```bash
# Scale web service
convox cloud scale web --count 3 --cpu 500 --memory 1024 -a rails-app -i your-machine-name

# Scale worker service
convox cloud scale worker --count 2 -a rails-app -i your-machine-name
```

### Convox Rack
```bash
# Scale web service
convox scale web --count 3 --cpu 500 --memory 1024 -a rails-app

# Scale worker service
convox scale worker --count 2 -a rails-app
```

## Common Commands

### View logs

Cloud:
```bash
convox cloud logs -a rails-app -i your-machine-name
```

Rack:
```bash
convox logs -a rails-app
```

### Rails console

Cloud:
```bash
convox cloud run web "bundle exec rails console" -a rails-app -i your-machine-name
```

Rack:
```bash
convox run web "bundle exec rails console" -a rails-app
```

### Database console

Cloud:
```bash
convox cloud run web "bundle exec rails dbconsole" -a rails-app -i your-machine-name
```

Rack:
```bash
convox run web "bundle exec rails dbconsole" -a rails-app
```

## Environment Variables

| Variable | Description | Required |
|----------|-------------|----------|
| `SECRET_KEY_BASE` | Rails secret key | Yes |
| `DATABASE_URL` | PostgreSQL connection (auto-set by Convox) | Auto |
| `REDIS_URL` | Redis connection (auto-set by Convox) | Auto |
| `RAILS_ENV` | Rails environment | Set to `production` |
| `WEB_CONCURRENCY` | Number of Puma workers | Optional (default: 2) |
| `RAILS_MAX_THREADS` | Max threads per worker | Optional (default: 5) |

## Troubleshooting

### Assets not loading
Ensure `RAILS_SERVE_STATIC_FILES` is set to `true` in production.

### Database connection errors
Check that migrations have run: `convox run web "rails db:migrate"`

### Background jobs not processing
Check worker logs: `convox logs --filter worker`

### Memory issues
Increase memory allocation: `convox scale web --memory 1024`

## Technology Stack

- Ruby 3.3.0
- Rails 7.1.2
- PostgreSQL 15
- Redis 7
- Puma 6.4
- Tailwind CSS 3
- Turbo & Stimulus
- Solid Queue & Solid Cache