class AddMergedPersonToPeople < ActiveRecord::Migration[6.1]
  def change
    add_reference :people, :merged_person, null: true, foreign_key: { to_table: :people }
  end
end
