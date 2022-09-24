class AddInstallmentsToPeople < ActiveRecord::Migration[6.1]
  def change
    add_column :people, :installment_amount, :decimal, precision: 8, scale: 2, default: 0
    add_column :people, :installment_due_on, :date
  end
end
