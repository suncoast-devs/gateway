class AddScholarshipsToProgramEnrollments < ActiveRecord::Migration[6.1]
  def change
    add_column :program_enrollments, :scholarships, :string, array: true, default: [], null: false
  end
end
