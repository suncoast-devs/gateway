# frozen_string_literal: true
class AddCloseUserToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :close_user, :string
    add_column :notes, :close_note, :string
  end
end
