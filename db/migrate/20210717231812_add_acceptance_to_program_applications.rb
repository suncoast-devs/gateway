class AddAcceptanceToProgramApplications < ActiveRecord::Migration[6.1]
  def change
    add_column :program_applications, :is_accepted, :boolean, null: false, default: false
  end
end
