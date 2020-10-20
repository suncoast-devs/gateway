class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.references :instigator, foreign_key: {to_table: :users}
      t.string :name
      t.jsonb :payload, null: false, default: '{}'

      t.timestamps
    end
  end
end
