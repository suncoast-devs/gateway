class CreateApplications < ActiveRecord::Migration[6.1]
  def change
    create_table :applications, id: :uuid do |t|
      t.uuid :aggregate_root
      t.integer :state
      t.jsonb :contact
      t.jsonb :responses
      t.timestamp :submitted_at
    end
  end
end
