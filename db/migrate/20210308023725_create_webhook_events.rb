class CreateWebhookEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :webhook_events do |t|
      t.string :name
      t.json :payload

      t.timestamps
    end
  end
end
