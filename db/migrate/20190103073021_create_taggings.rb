# frozen_string_literal: true
class CreateTaggings < ActiveRecord::Migration[5.2]
  def change
    create_table :taggings do |t|
      t.references :tag, foreign_key: true
      t.references :taggable, polymorphic: true

      t.timestamps
    end
  end
end
