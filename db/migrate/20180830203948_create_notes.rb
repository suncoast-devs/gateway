class CreateNotes < ActiveRecord::Migration[5.2]
  def change
    create_table :notes do |t|
      t.references :notable, polymorphic: true
      t.references :user, foreign_key: true
      t.text :message

      t.timestamps
    end
  end
end
