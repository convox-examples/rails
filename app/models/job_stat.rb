class JobStat < ApplicationRecord
  # This is a simple model to track job statistics
  # In production, you'd use Solid Queue's built-in tracking
  
  enum status: {
    pending: 0,
    processing: 1,
    completed: 2,
    failed: 3
  }
  
  scope :recent, -> { where('created_at >= ?', 24.hours.ago) }
  scope :today, -> { where('created_at >= ?', Date.current.beginning_of_day) }
  
  def self.pending_count
    # Simulated for demo - in production, query Solid Queue
    rand(0..10)
  end
  
  def self.completed_count
    # Simulated for demo
    rand(50..200)
  end
  
  def self.failed_count
    # Simulated for demo
    rand(0..5)
  end
  
  def self.completed_today
    # Simulated for demo
    rand(20..100)
  end
end