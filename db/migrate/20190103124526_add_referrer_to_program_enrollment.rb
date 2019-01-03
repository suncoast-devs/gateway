class AddReferrerToProgramEnrollment < ActiveRecord::Migration[5.2]
  def change
    add_column :program_enrollments, :referrer, :string
  end
end
