# frozen_string_literal: true
class AddStudentStatusShortUrlToProgramEnrollments < ActiveRecord::Migration[5.2]
  def change
    add_column :program_enrollments, :student_status_url, :string
  end
end
