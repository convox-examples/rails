# Rack::Attack configuration for rate limiting and security

class Rack::Attack
  # Use Redis for throttle data storage if available
  # Convox provides CACHE_URL for the redis resource
  if ENV['CACHE_URL'].present?
    Rack::Attack.cache.store = ActiveSupport::Cache::RedisCacheStore.new(url: ENV['CACHE_URL'])
  end
  
  # Throttle all requests by IP (60 requests per minute)
  throttle('req/ip', limit: 60, period: 1.minute) do |req|
    req.ip unless req.path.start_with?('/health')
  end
  
  # Throttle API requests by IP (100 requests per minute)
  throttle('api/ip', limit: 100, period: 1.minute) do |req|
    req.ip if req.path.start_with?('/api')
  end
  
  # Throttle login attempts (5 requests per 20 seconds)
  throttle('logins/ip', limit: 5, period: 20.seconds) do |req|
    if req.path == '/login' && req.post?
      req.ip
    end
  end
  
  # Block suspicious requests
  blocklist('block suspicious requests') do |req|
    # Block requests with suspicious user agents
    Rack::Attack::Fail2Ban.filter("pentesters-#{req.ip}", maxretry: 3, findtime: 10.minutes, bantime: 5.minutes) do
      CGI.unescape(req.query_string) =~ %r{/etc/passwd} ||
      req.path.include?('/etc/passwd') ||
      req.path.include?('..') ||
      req.path.include?('\\x')
    end
  end
  
  # Safelist localhost and health check paths
  safelist('allow localhost') do |req|
    req.ip == '127.0.0.1' || req.ip == '::1'
  end
  
  safelist('allow health checks') do |req|
    req.path == '/health' || req.path == '/up'
  end
  
  # Custom response for throttled requests
  self.throttled_responder = lambda do |_env|
    [
      429,
      { 'Content-Type' => 'application/json' },
      [{ error: 'Rate limit exceeded. Please try again later.' }.to_json]
    ]
  end
end