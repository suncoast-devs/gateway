class CreateContactDispositions < ActiveRecord::Migration[6.0]
  def change
    create_table :contact_dispositions do |t|
      t.references :person, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :code, null: false, default: 0
      t.timestamp :contacted_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.timestamps
    end

    add_reference :people, :last_contact_disposition, foreign_key: {to_table: :contact_dispositions}
  end
end
