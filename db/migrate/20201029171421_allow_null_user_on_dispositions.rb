class AllowNullUserOnDispositions < ActiveRecord::Migration[6.0]
  def change
    change_column_null :contact_dispositions, :user_id, true
  end
end
