class ApplicationController < ActionController::Base
  # CSRF protection
  protect_from_forgery with: :exception
  
  # Set process start time for uptime tracking
  before_action :set_process_start_time
  
  private
  
  def set_process_start_time
    $PROCESS_START_TIME ||= Time.current
  end
end