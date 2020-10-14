class AddNoteAndScheduleToCohorts < ActiveRecord::Migration[5.2]
  def change
    add_column :cohorts, :format, :string
    add_column :cohorts, :note, :string
    add_column :cohorts, :delivery, :string
  end
end
