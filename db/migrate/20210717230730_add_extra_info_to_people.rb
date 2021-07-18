class AddExtraInfoToPeople < ActiveRecord::Migration[6.1]
  def change
    add_column :people, :diversity_women, :boolean
    add_column :people, :diversity_underserved, :boolean
    add_column :people, :diversity_lgbtq, :boolean
    add_column :people, :diversity_other, :boolean
    add_column :people, :allergy_note, :string
    add_column :people, :medical_note, :string
    add_column :people, :personal_note, :string
    add_column :people, :date_of_birth, :date
    add_column :people, :mailing_address, :text
    add_column :people, :media_release, :boolean
    add_column :people, :emergency_contact_name, :string
    add_column :people, :emergency_contact_phone_number, :string
  end
end
