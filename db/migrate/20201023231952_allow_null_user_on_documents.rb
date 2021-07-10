# frozen_string_literal: true
class AllowNullUserOnDocuments < ActiveRecord::Migration[6.0]
  def change
    change_column_null :documents, :user_id, true
  end
end
