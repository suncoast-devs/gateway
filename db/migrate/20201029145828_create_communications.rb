class CreateCommunications < ActiveRecord::Migration[6.0]
  def change
    create_table :communications do |t|
      t.references :person, null: false, foreign_key: true
      t.references :user, null: true, foreign_key: true
      t.integer :media, null: false, default: 0
      t.boolean :is_unread, null: false, default: true
      t.text :subject
      t.text :body
      t.jsonb :data, default: "{}", null: false
      t.timestamp :messaged_at

      t.timestamps
    end
  end
end
