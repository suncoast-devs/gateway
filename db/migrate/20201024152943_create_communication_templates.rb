class CreateCommunicationTemplates < ActiveRecord::Migration[6.0]
  def change
    create_table :communication_templates do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.string :title
      t.string :body
      t.string :key
      t.integer :media, null: false, default: 0
      t.boolean :is_system, null: false, default: false

      t.timestamps
    end
  end
end
