class CreateLedgerEntries < ActiveRecord::Migration[6.1]
  def change
    create_table :ledger_entries do |t|
      t.references :person, null: false, foreign_key: true
      t.references :invoice, null: true, foreign_key: true
      t.decimal :amount, precision: 8, scale: 2
      t.string :description

      t.timestamps
    end
  end
end
