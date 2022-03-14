class AddUpdatedColumnsToProgramAcceptances < ActiveRecord::Migration[6.1]
  def change
    add_column :program_acceptances, :is_update, :boolean, null: false, default: false
    add_column :program_acceptances, :note, :text
  end
end
