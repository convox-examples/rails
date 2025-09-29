class User < ApplicationRecord
  # Validations
  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :email, presence: true, uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  
  # Callbacks
  before_save :downcase_email
  
  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :active_today, -> { where('updated_at >= ?', Date.current.beginning_of_day) }
  scope :created_this_week, -> { where('created_at >= ?', 1.week.ago) }
  
  # Instance methods
  def display_name
    name.presence || email.split('@').first
  end
  
  private
  
  def downcase_email
    self.email = email.downcase if email.present?
  end
end