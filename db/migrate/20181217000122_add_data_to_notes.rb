# frozen_string_literal: true
class AddDataToNotes < ActiveRecord::Migration[5.2]
  def change
    add_column :notes, :data, :jsonb, null: false, default: '{}'
    add_column :notes, :note_type, :text
    Note.reset_column_information
    Note.update_all(note_type: 'comment')
  end
end
