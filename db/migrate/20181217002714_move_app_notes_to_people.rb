# frozen_string_literal: true
class MoveAppNotesToPeople < ActiveRecord::Migration[5.2]
  def change
    rename_column :notes, :notable_id, :legacy_notable_id
    add_column :notes, :notable_id, :bigint
    Note.reset_column_information

    Note.where(notable_type: 'ProgramApplication').each do |note|
      program_application = ProgramApplication.find(note.legacy_notable_id)
      note.update notable: program_application.person
    end

    remove_column :notes, :legacy_notable_id
  end
end
