class CreateProgramAcceptances < ActiveRecord::Migration[5.2]
  def change
    create_table :program_acceptances do |t|
      t.references :person, foreign_key: true
      t.references :cohort, foreign_key: true
      t.references :program_application, type: :uuid, foreign_key: true
      t.references :deposit_invoice, foreign_key: {to_table: :invoices}
      t.integer :tuition_reduction, null: false, default: 0
      t.string :enrollment_agreement_url
      t.text :notification_body
      t.timestamp :sent_at

      t.timestamps
    end
  end
end
