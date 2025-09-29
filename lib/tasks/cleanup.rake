namespace :cleanup do
  desc "Clean up old records and optimize database"
  task old_records: :environment do
    puts "Starting cleanup task at #{Time.current}"
    
    # Clean up old job stats (keep last 30 days)
    old_jobs = JobStat.where('created_at < ?', 30.days.ago)
    count = old_jobs.count
    old_jobs.destroy_all
    puts "Removed #{count} old job stats"
    
    # Clean up orphaned data (example)
    # Add your cleanup logic here
    
    # Log cleanup completion
    puts "Cleanup completed at #{Time.current}"
  end
  
  desc "Optimize database tables"
  task optimize: :environment do
    puts "Optimizing database..."
    
    # Run VACUUM on PostgreSQL
    ActiveRecord::Base.connection.execute("VACUUM ANALYZE")
    
    puts "Database optimization completed"
  end
  
  desc "Run all cleanup tasks"
  task all: [:old_records, :optimize] do
    puts "All cleanup tasks completed"
  end
end