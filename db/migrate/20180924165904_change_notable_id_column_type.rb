# frozen_string_literal: true
class ChangeNotableIdColumnType < ActiveRecord::Migration[5.2]
  def change
    remove_column :notes, :notable_id
    add_column :notes, :notable_id, :uuid, foreign_key: true
  end
end
