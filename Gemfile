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
gem 'psych', '~> 5.0'

# Assets
gem 'sassc-rails'

# API
gem 'rack-cors'

# Monitoring
gem 'rack-attack'

group :development, :test do
  gem 'debug', platforms: %i[ mri windows ]
end

group :development do
  gem 'web-console'
  gem 'listen', '~> 3.8'
end

group :test do
  gem 'capybara'
  gem 'selenium-webdriver'
end