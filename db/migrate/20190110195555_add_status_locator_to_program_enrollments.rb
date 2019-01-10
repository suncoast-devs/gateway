class AddStatusLocatorToProgramEnrollments < ActiveRecord::Migration[5.2]
  def change
    add_column :program_enrollments, :status_locator, :uuid, index: true, null: false, default: -> { "gen_random_uuid()" }
  end
end
