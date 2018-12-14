class CreateCohorts < ActiveRecord::Migration[5.2]
  def change
    create_table :cohorts do |t|
      t.string :name
      t.date :begins_on
      t.date :ends_on

      t.timestamps
    end
  end
end
