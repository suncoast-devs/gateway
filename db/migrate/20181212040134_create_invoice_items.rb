class CreateInvoiceItems < ActiveRecord::Migration[5.2]
  def change
    create_table :invoice_items do |t|
      t.references :invoice, foreign_key: true
      t.string :description
      t.integer :quantity
      t.decimal :amount, precision: 8, scale: 2

      t.timestamps
    end
  end
end
