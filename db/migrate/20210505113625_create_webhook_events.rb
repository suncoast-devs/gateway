# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table :webhook_events do
      column :id, :uuid, null: false, primary_key: true, default: Sequel.function(:uuid_generate_v4)
      column :name, :text, null: false
      column :payload, :jsonb, null: false
      column :received_at, :timestamp, null: false
      column :executed_at, :timestamp, null: true
    end
  end
end
