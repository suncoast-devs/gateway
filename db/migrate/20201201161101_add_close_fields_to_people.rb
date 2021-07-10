# frozen_string_literal: true
class AddCloseFieldsToPeople < ActiveRecord::Migration[6.0]
  def change
    add_column :people, :close_lead, :string
    add_column :people, :close_contact, :string
    add_column :program_enrollments, :close_opportunity, :string
  end
end
