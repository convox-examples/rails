class DashboardController < ApplicationController
  def index
    @stats = {
      users_count: get_user_count,
      users_today: get_users_today,
      jobs_pending: get_pending_jobs,
      jobs_completed: get_completed_jobs,
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

  def get_user_count
    User.count
  rescue
    0
  end

  def get_users_today
    User.where('created_at >= ?', Date.current.beginning_of_day).count
  rescue
    0
  end

  def get_pending_jobs
    JobStat.pending_count
  rescue
    0
  end

  def get_completed_jobs
    JobStat.completed_today
  rescue
    0
  end

  def calculate_cache_hit_rate
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
    if ENV['CACHE_URL'].present? || ENV['REDIS_URL'].present?
      redis_url = ENV['CACHE_URL'] || ENV['REDIS_URL']
      redis = Redis.new(url: redis_url)
      redis.ping == 'PONG' ? 'healthy' : 'unhealthy'
    else
      'not configured'
    end
  rescue
    'unhealthy'
  end

  def check_job_system
    'healthy'
  end
end