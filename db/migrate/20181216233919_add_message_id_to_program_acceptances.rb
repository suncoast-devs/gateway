# frozen_string_literal: true
class AddMessageIdToProgramAcceptances < ActiveRecord::Migration[5.2]
  def change
    add_column :program_acceptances, :message_id, :string
  end
end
