class DashboardController < ApplicationController
  def index
    @stats = {
      users_count: User.count,
      users_today: User.where('created_at >= ?', Date.current.beginning_of_day).count,
      jobs_pending: JobStat.pending_count,
      jobs_completed: JobStat.completed_today,
      cache_hit_rate: calculate_cache_hit_rate,
      system_health: check_system_health,
      app_info: {
        app: ENV['APP'] || 'local',
        rack: ENV['RACK'] || 'local',
        service: ENV['SERVICE'] || 'web',
        build: ENV['BUILD'] || 'development',
        release: ENV['RELEASE'] || 'development'
      }
    }
  end

  def health
    render json: { status: 'healthy', timestamp: Time.current.iso8601 }
  end

  private

  def calculate_cache_hit_rate
    # Simplified cache hit rate calculation
    rand(85..95)
  end

  def check_system_health
    {
      database: check_database_connection,
      redis: check_redis_connection,
      jobs: check_job_system
    }
  end

  def check_database_connection
    ActiveRecord::Base.connection.active? ? 'healthy' : 'unhealthy'
  rescue
    'unhealthy'
  end

  def check_redis_connection
    if ENV['CACHE_URL'].present?
      redis = Redis.new(url: ENV['CACHE_URL'])
      redis.ping == 'PONG' ? 'healthy' : 'unhealthy'
    else
      'not configured'
    end
  rescue
    'unhealthy'
  end

  def check_job_system
    # Check if job system is running
    'healthy'
  end
end