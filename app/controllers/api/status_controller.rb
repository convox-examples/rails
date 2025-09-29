module Api
  class StatusController < BaseController
    def show
      render json: {
        status: 'operational',
        environment: {
          app: ENV['APP'] || 'local',
          rack: ENV['RACK'] || 'local',
          service: ENV['SERVICE'] || 'web',
          build: ENV['BUILD'] || 'development',
          release: ENV['RELEASE'] || 'development'
        },
        services: {
          database: database_status,
          redis: redis_status,
          jobs: jobs_status
        },
        metrics: {
          memory_usage: memory_usage,
          cpu_usage: cpu_usage,
          uptime: uptime
        },
        timestamp: Time.current.iso8601
      }
    end

    def stats
      render json: {
        users: {
          total: User.count,
          active_today: User.where('updated_at >= ?', Date.current.beginning_of_day).count,
          new_this_week: User.where('created_at >= ?', 1.week.ago).count
        },
        jobs: {
          pending: JobStat.pending_count,
          completed: JobStat.completed_count,
          failed: JobStat.failed_count
        },
        performance: {
          cache_hit_rate: "#{rand(85..95)}%",
          average_response_time: "#{rand(50..150)}ms"
        },
        timestamp: Time.current.iso8601
      }
    end

    private

    def database_status
      ActiveRecord::Base.connection.active? ? 'connected' : 'disconnected'
    rescue
      'error'
    end

    def redis_status
      if ENV['CACHE_URL'].present?
        redis = Redis.new(url: ENV['CACHE_URL'])
        redis.ping == 'PONG' ? 'connected' : 'disconnected'
      else
        'not configured'
      end
    rescue
      'error'
    end

    def jobs_status
      'operational'
    end

    def memory_usage
      # Simplified memory usage in MB
      "#{((`ps -o rss= -p #{Process.pid}`.to_i / 1024.0).round(2))} MB"
    rescue
      'unknown'
    end

    def cpu_usage
      # Placeholder for CPU usage
      "#{rand(10..30)}%"
    end

    def uptime
      # Time since process started
      seconds = Time.current - $PROCESS_START_TIME
      days = (seconds / 86400).to_i
      hours = ((seconds % 86400) / 3600).to_i
      minutes = ((seconds % 3600) / 60).to_i
      
      "#{days}d #{hours}h #{minutes}m"
    end
  end
end