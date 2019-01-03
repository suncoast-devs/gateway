class ChangeDepositRequiredDefault < ActiveRecord::Migration[5.2]
  def change
    change_column_default :program_enrollments, :deposit_required, true
  end
end
