class AddPaymentURLToProgramAcceptances < ActiveRecord::Migration[6.1]
  def change
    add_column :program_acceptances, :payment_url, :string
    change_column_default :program_enrollments, :deposit_required, false
  end
end
