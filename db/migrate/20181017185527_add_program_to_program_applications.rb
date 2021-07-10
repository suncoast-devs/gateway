# frozen_string_literal: true
class AddProgramToProgramApplications < ActiveRecord::Migration[5.2]
  def change
    add_column :program_applications, :program, :string
    ProgramApplication.reset_column_information
    ProgramApplication.update_all(program: 'web_development')
  end
end
