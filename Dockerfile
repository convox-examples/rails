# syntax=docker/dockerfile:1
FROM ruby:3.3-slim AS base

# Install base dependencies including libyaml for psych gem
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    git \
    libpq-dev \
    postgresql-client \
    libyaml-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js 20 and Yarn
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g yarn && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Development stage
FROM base AS development

ENV RAILS_ENV=development
ENV BUNDLE_PATH=/bundle
ENV BUNDLE_BIN=/bundle/bin
ENV PATH="${BUNDLE_BIN}:${PATH}"

# Copy only Gemfile first to leverage Docker cache
COPY Gemfile ./
# Generate Gemfile.lock and install dependencies
RUN bundle install --jobs 4 --retry 3

# Copy only package.json first to leverage Docker cache
COPY package.json ./
# Generate yarn.lock and install dependencies
RUN yarn install

# Copy application code
COPY . .

# Skip asset precompilation in development
# RUN SECRET_KEY_BASE=dummy bundle exec rails assets:precompile

# Create and use non-root user
RUN useradd -m -u 1000 rails && \
    chown -R rails:rails /app /bundle
USER rails

EXPOSE 3000
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]

# Production stage
FROM base AS production

ENV RAILS_ENV=production
ENV RAILS_SERVE_STATIC_FILES=true
ENV RAILS_LOG_TO_STDOUT=true

# Copy only Gemfile first to leverage Docker cache
COPY Gemfile ./
# Install production dependencies using modern bundle config
RUN bundle config set --local without 'development test' && \
    bundle config set --local jobs '4' && \
    bundle config set --local retry '3' && \
    bundle install && \
    rm -rf /usr/local/bundle/cache/*.gem && \
    find /usr/local/bundle/gems/ -name "*.c" -delete && \
    find /usr/local/bundle/gems/ -name "*.o" -delete

# Copy only package.json first to leverage Docker cache
COPY package.json ./
# Install production Node dependencies (generates yarn.lock if needed)
RUN yarn install --production --network-timeout 100000 && \
    yarn cache clean

# Copy application code
COPY . .

# Skip asset precompilation for now - not using complex assets
# ARG SECRET_KEY_BASE
# RUN SECRET_KEY_BASE=${SECRET_KEY_BASE:-dummy} bundle exec rails assets:precompile

# Clean up unnecessary files
RUN rm -rf node_modules tmp/cache vendor/assets test spec

# Create and use non-root user
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