class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.references :event, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.timestamp :acknowledged_at

      t.timestamps
    end

    add_column :users, :is_notifiable, :boolean, null: false, default: false
  end
end
