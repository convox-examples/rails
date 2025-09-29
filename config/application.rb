require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile
Bundler.require(*Rails.groups)

module ConvoxRails
  class Application < Rails::Application
    # Initialize configuration defaults for Rails 7.1
    config.load_defaults 7.1
    
    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w(assets tasks))
    
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    
    # Set time zone
    # config.time_zone = "Central Time (US & Canada)"
    
    # Set default locale
    # config.i18n.default_locale = :de
    
    # Don't generate system test files
    config.generators.system_tests = nil
    
    # Use default Active Job adapter
    # config.active_job.queue_adapter = :solid_queue
    
    # Use Redis for caching if available
    # In production, Convox provides CACHE_URL for Redis
    if ENV['CACHE_URL'].present?
      config.cache_store = :redis_cache_store, { url: ENV['CACHE_URL'] }
    else
      config.cache_store = :memory_store
    end
    
    # Allow Convox domains in development
    if Rails.env.development?
      config.hosts << ".convox.local"
      config.hosts << ".convox.cloud"
    end
    
    # CORS configuration for API
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '/api/*',
          headers: :any,
          methods: [:get, :post, :put, :patch, :delete, :options, :head]
      end
    end
    
    # Rack Attack for rate limiting
    config.middleware.use Rack::Attack
  end
end

# Track process start time for uptime calculation
$PROCESS_START_TIME = Time.current