# frozen_string_literal: true
class AddExpandedNamesToPeople < ActiveRecord::Migration[5.2]
  def change
    add_column :people, :given_name, :string
    add_column :people, :family_name, :string
    add_column :people, :middle_name, :string
    add_column :people, :client_ip_address, :string

    Person.reset_column_information

    Person.all.each do |person|
      given_name, family_name = FullNameSplitter.split(person.full_name)
      given_name, middle_name = FullNameSplitter.split(given_name)

      person.update({
        given_name: given_name,
        family_name: family_name,
        middle_name: middle_name,
        client_ip_address: '127.0.0.1'
      })
    end
  end
end
