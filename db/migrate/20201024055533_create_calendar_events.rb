class CreateCalendarEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :calendar_events do |t|
      t.references :person, null: true, foreign_key: true
      t.string :name
      t.string :uuid
      t.timestamp :starts_at
      t.timestamp :ends_at
      t.boolean :is_canceled
      t.jsonb :data

      t.timestamps
    end
  end
end
