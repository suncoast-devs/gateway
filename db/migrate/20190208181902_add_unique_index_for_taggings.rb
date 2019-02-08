class AddUniqueIndexForTaggings < ActiveRecord::Migration[5.2]
  def change
    add_index :taggings, [:tag_id, :taggable_type, :taggable_id], unique: true
  end
end
