# frozen_string_literal: true
class AddAcContactIdentifierToPeople < ActiveRecord::Migration[5.2]
  def change
    add_column :people, :ac_contact_identifier, :string
  end
end
