require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.enable_reloading = false

  # Eager load code on boot.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  # Ensures that a master key has been made available
  config.require_master_key = false

  # Enable serving static files for Convox
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?

  # Do not fall back to assets pipeline if a precompiled asset is missed.
  config.assets.compile = false

  # Store uploaded files on the local file system
  config.active_storage.variant_processor = :mini_magick if defined?(ActiveStorage)

  # SSL Configuration for Convox
  # Convox handles SSL termination at the load balancer level
  # The app receives plain HTTP traffic on port 3000
  config.force_ssl = false
  
  # This tells Rails to assume it's behind an SSL-terminating proxy
  # It will set secure cookies and HSTS headers appropriately
  config.assume_ssl = true

  # Log level configuration
  config.log_level = ENV.fetch("LOG_LEVEL", "info")

  # Prepend all log lines with the following tags.
  config.log_tags = [ :request_id ]

  # Use Redis cache if available
  if ENV['REDIS_URL'].present?
    config.cache_store = :redis_cache_store, { url: ENV['REDIS_URL'] }
  end

  # Enable locale fallbacks for I18n
  config.i18n.fallbacks = true

  # Don't log any deprecations.
  config.active_support.report_deprecations = false

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  # HOST AUTHORIZATION
  # For simplicity in this example, we allow all hosts
  # In production, you might want to restrict to specific domains
  if ENV['ALLOW_ALL_HOSTS'].present? && ENV['ALLOW_ALL_HOSTS'] == 'true'
    config.hosts.clear
  else
    # More restrictive option (not used by default in this example)
    config.hosts = [
      /\.convox\.cloud\z/,
      /\.convox\.local\z/,
      /\A10\.\d+\.\d+\.\d+\z/,
      /\A172\.(1[6-9]|2[0-9]|3[0-1])\.\d+\.\d+\z/,
      "localhost"
    ]
  end

  # Use default logging formatter
  config.log_formatter = ::Logger::Formatter.new

  # Log to STDOUT in production
  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end
end