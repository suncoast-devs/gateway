class CreateInquiryEvents < ActiveRecord::Migration[6.1]
  def change
    enable_extension "pgcrypto"
    create_table :inquiry_events do |t|
      t.string :type
      t.uuid :aggregate, index: true
      t.jsonb :payload
      t.jsonb :metadata
      t.timestamps
    end
  end
end
