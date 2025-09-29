source 'https://rubygems.org'

ruby '~> 3.3.0'

# Core Rails gems
gem 'rails', '~> 7.1.2'
gem 'sprockets-rails'
gem 'pg', '~> 1.5'
gem 'puma', '~> 6.4'
gem 'importmap-rails'
gem 'turbo-rails'
gem 'stimulus-rails'
gem 'jbuilder'
gem 'redis', '~> 5.0'
gem 'bootsnap', require: false
gem 'image_processing', '~> 1.2'
gem 'psych', '~> 5.0'  # YAML parser, explicitly included

# Background jobs
# gem 'solid_queue', '~> 0.2'  # Requires additional setup

# Caching  
# gem 'solid_cache', '~> 0.2'  # Requires additional setup

# Assets
gem 'sassc-rails'
# gem 'tailwindcss-rails'  # Removed - not using Tailwind in this example

# API
gem 'rack-cors'

# Monitoring
gem 'rack-attack'

group :development, :test do
  gem 'debug', platforms: %i[ mri windows ]
  gem 'rspec-rails', '~> 6.1'
  gem 'factory_bot_rails'
  gem 'faker'
end

group :development do
  gem 'web-console'
  gem 'listen', '~> 3.8'
  gem 'spring'
end

group :test do
  gem 'capybara'
  gem 'selenium-webdriver'
end