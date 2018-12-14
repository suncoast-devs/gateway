class CreateProgramAcceptances < ActiveRecord::Migration[5.2]
  def change
    create_table :program_acceptances do |t|
      t.references :person, foreign_key: true
      t.references :cohort, foreign_key: true
      t.references :deposit_invoice, foreign_key: true
      t.integer :tuition_reduction, null:false, default: 0
      t.text :notification_body
      t.timestamp :sent_at

      t.timestamps
    end
  end
end
