class AddDirectionToCommunications < ActiveRecord::Migration[6.0]
  def change
    add_column :communications, :direction, :integer, null: false, default: 0
  end
end
