class CreateEmploymentRecords < ActiveRecord::Migration[6.1]
  def change
    create_table :employment_records do |t|
      t.references :person, null: false, foreign_key: true
      t.string :company
      t.string :title
      t.string :position_type
      t.boolean :is_development, null: false, default: true
      t.date :started_on
      t.boolean :is_started_on_approximate, null: false, default: false
      t.date :ended_on
      t.boolean :is_ended_on_approximate, null: false, default: false
      t.integer :salary
      t.string :source

      t.timestamps
    end
  end
end
