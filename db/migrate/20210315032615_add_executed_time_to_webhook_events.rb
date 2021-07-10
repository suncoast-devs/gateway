# frozen_string_literal: true
class AddExecutedTimeToWebhookEvents < ActiveRecord::Migration[6.1]
  def change
    add_column :webhook_events, :executed_at, :timestamp
  end
end
