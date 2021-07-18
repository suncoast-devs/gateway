class AddPostGradInfoToProgramEnrollments < ActiveRecord::Migration[6.1]
  def change
    add_column :program_enrollments, :graduated_on, :date
    add_column :program_enrollments, :dropped_on, :date
    add_column :program_enrollments, :is_seeking_employment, :boolean, null: false, default: true
  end
end
