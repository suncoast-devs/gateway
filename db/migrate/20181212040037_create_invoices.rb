class CreateInvoices < ActiveRecord::Migration[5.2]
  def change
    create_table :invoices do |t|
      t.references :person, foreign_key: true
      t.date :due_on
      t.string :stripe_id
      t.string :payment_url
      t.boolean :is_paid

      t.timestamps
    end
  end
end
