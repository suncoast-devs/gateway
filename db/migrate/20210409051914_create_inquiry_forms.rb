class CreateInquiryForms < ActiveRecord::Migration[6.1]
  def change
    create_table :inquiry_forms do |t|
      t.uuid :aggregate, index: true
      t.string :form_title
      t.string :contact_name
      t.string :contact_email
      t.string :contact_phone
      t.jsonb :responses
      t.boolean :is_complete
      t.timestamps
    end
  end
end
