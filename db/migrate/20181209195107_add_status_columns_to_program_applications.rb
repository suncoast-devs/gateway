class AddStatusColumnsToProgramApplications < ActiveRecord::Migration[5.2]
  def change
    add_column :program_applications, :application_status, :integer, default: 0
    add_column :program_applications, :interview_status, :integer, default: 0
    add_column :program_applications, :acceptance_status, :integer, default: 0
    add_column :program_applications, :is_hidden, :boolean, default: false
  end
end
