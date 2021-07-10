# frozen_string_literal: true
class AddAcStudentStatusUrlFieldToProgramEnrollments < ActiveRecord::Migration[5.2]
  def change
    add_column :program_enrollments, :ac_student_status_url_field, :string
  end
end
