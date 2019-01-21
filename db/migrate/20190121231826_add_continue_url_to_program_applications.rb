class AddContinueUrlToProgramApplications < ActiveRecord::Migration[5.2]
  def change
    add_column :program_applications, :continue_url, :string
  end
end
