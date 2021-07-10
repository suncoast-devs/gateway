# frozen_string_literal: true
class ConvertNoteTypesToInterviewNote < ActiveRecord::Migration[5.2]
  def change
    execute "UPDATE notes SET note_type = 'interview-note' WHERE note_type = 'comment';"
  end
end
