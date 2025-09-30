# This file should contain all the record creation needed to seed the database with its default values.

puts "Seeding database..."

# Create sample users
users = [
  { name: "Alice Johnson", email: "alice@example.com", bio: "Software engineer passionate about Rails and cloud technologies." },
  { name: "Bob Smith", email: "bob@example.com", bio: "DevOps specialist with expertise in containerization." },
  { name: "Charlie Brown", email: "charlie@example.com", bio: "Full-stack developer focused on scalable applications." },
  { name: "Diana Prince", email: "diana@example.com", bio: "Cloud architect designing resilient systems." },
  { name: "Eve Wilson", email: "eve@example.com", bio: "Backend developer specializing in API design." }
]

users.each do |user_attrs|
  User.find_or_create_by!(email: user_attrs[:email]) do |user|
    user.name = user_attrs[:name]
    user.bio = user_attrs[:bio]
  end
end

puts "Created #{User.count} users"

# Create sample job stats (for demo purposes)
10.times do
  JobStat.create!(
    job_name: ["EmailJob", "ReportJob", "DataSyncJob", "CleanupJob"].sample,
    status: JobStat.statuses.keys.sample,
    started_at: rand(1..24).hours.ago,
    completed_at: rand(1..60).minutes.ago,
    metadata: { processed: rand(10..1000), duration: rand(1..300) }
  )
end

puts "Created #{JobStat.count} job stats"
puts "Seeding completed!"