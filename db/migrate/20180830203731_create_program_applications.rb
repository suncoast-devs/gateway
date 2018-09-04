# frozen_string_literal: true

class CreateProgramApplications < ActiveRecord::Migration[5.2]
  def change
    enable_extension 'pgcrypto'

    create_table :program_applications, id: :uuid do |t|
      t.string :full_name
      t.string :email_address
      t.string :phone_number
      t.string :crm_identifier
      t.boolean :academic_signoff
      t.boolean :administrative_signoff
      t.json :question_responses

      t.timestamps
    end
  end
end
