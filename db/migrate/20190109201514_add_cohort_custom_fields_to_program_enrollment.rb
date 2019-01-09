class AddCohortCustomFieldsToProgramEnrollment < ActiveRecord::Migration[5.2]
  def change
    add_column :program_enrollments, :ac_cohort_start_date_field, :string
    add_column :program_enrollments, :ac_cohort_name_field, :string
  end
end
