class AddUniqueIndexForInvoiceOnLedgerEntries < ActiveRecord::Migration[6.1]
  def change
    remove_reference :ledger_entries, :invoice
    add_reference :ledger_entries, :invoice, foreign_key: true, null: true, index: { unique: true }
  end
end
