# frozen_string_literal: true
class AddRescindedToProgramAcceptances < ActiveRecord::Migration[5.2]
  def change
    add_column :program_acceptances, :is_rescinded, :boolean, default: false
  end
end
