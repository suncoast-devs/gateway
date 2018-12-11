class CreatePeople < ActiveRecord::Migration[5.2]
  def change
    create_table :people do |t|
      t.string :full_name
      t.string :email_address
      t.string :phone_number
      t.string :crm_identifier
      t.string :crm_url
      t.string :source

      t.timestamps
    end

    add_reference :program_applications, :person, foreign_key: true

    ProgramApplication.reset_column_information
    Person.reset_column_information

    say "Migrating existing program applications."

    ProgramApplication.all.each do |program_application|
      say program_application.full_name, :subitem
      Person.where(email_address: program_application.email_address).first_or_initialize do |person|
        person.full_name ||= program_application.full_name
        person.phone_number ||= program_application.phone_number
        person.crm_identifier ||= program_application.crm_identifier
        person.crm_url ||= program_application.crm_url
        person.source ||= "#{program_application.program.parameterize}-program-application"
        person.save!
        program_application.update(person: person)
      end
    end

    remove_column :program_applications, :full_name
    remove_column :program_applications, :email_address
    remove_column :program_applications, :phone_number
    remove_column :program_applications, :crm_identifier
    remove_column :program_applications, :crm_url
  end
end
