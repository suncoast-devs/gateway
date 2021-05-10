# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table :webhook_events do
      column :id, :uuid, null: false, primary_key: true, default: Sequel.function(:uuid_generate_v4)
      column :name, :text
      column :payload, :text
      column :received_at, :timestamp
      column :executed_at, :timestamp
    end
  end
end
