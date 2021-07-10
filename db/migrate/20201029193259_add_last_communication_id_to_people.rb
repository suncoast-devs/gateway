# frozen_string_literal: true
class AddLastCommunicationIdToPeople < ActiveRecord::Migration[6.0]
  def change
    add_reference :people, :last_communication, null: true, foreign_key: { to_table: :communications }
  end
end
