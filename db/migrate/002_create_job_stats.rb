class CreateJobStats < ActiveRecord::Migration[7.1]
  def change
    create_table :job_stats do |t|
      t.string :job_name
      t.integer :status, default: 0, null: false
      t.json :metadata
      t.datetime :started_at
      t.datetime :completed_at
      
      t.timestamps
    end
    
    add_index :job_stats, :status
    add_index :job_stats, :created_at
  end
end