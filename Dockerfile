# syntax=docker/dockerfile:1
FROM ruby:3.3-slim AS base

# Install base dependencies
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    git \
    libpq-dev \
    postgresql-client \
    libyaml-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js 20
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g yarn && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Production stage
FROM base AS production

ENV RAILS_ENV=production
ENV RAILS_SERVE_STATIC_FILES=true
ENV RAILS_LOG_TO_STDOUT=true

# Copy Gemfile (without lock file since we generate it in Docker)
COPY Gemfile ./

# Install dependencies and generate Gemfile.lock
RUN bundle config set --local without 'development test' && \
    bundle install --jobs 4 --retry 3 && \
    rm -rf /usr/local/bundle/cache/*.gem && \
    find /usr/local/bundle/gems/ -name "*.c" -delete && \
    find /usr/local/bundle/gems/ -name "*.o" -delete

# Copy package.json for Node dependencies
COPY package.json ./

# Install Node dependencies (generates lock file if needed)
RUN yarn install --production && \
    yarn cache clean

# Copy application code
COPY . .

# Precompile assets (skip for now as we're not using the asset pipeline heavily)
# RUN SECRET_KEY_BASE=dummy bundle exec rails assets:precompile

# Clean up
RUN rm -rf tmp/cache vendor/assets test spec log/*.log

# Create non-root user
RUN useradd -m -u 1000 rails && \
    chown -R rails:rails /app && \
    mkdir -p /app/tmp/pids /app/log && \
    chown -R rails:rails /app/tmp /app/log

USER rails

EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:3000/health || exit 1

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]