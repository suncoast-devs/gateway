class MakeLedgerEntryNonnull < ActiveRecord::Migration[6.1]
  def change
    change_column_null :ledger_entries, :amount, false, 0
  end
end
