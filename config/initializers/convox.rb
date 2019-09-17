Rails.application.configure do
  config.before_configuration do
    pp config.logger
  end

  # loosen some checks for development
  if Rails.env.development?
    config.hosts.clear # allow all hostnames
    config.webpacker.check_yarn_integrity = false
  end

end
