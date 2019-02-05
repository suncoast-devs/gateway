class MoveApplicationColumnsToEnrollments < ActiveRecord::Migration[5.2]
  def change
    add_column :program_enrollments, :academic_signoff, :boolean
    add_column :program_enrollments, :administrative_signoff, :boolean
    execute "UPDATE program_enrollments e SET academic_signoff = a.academic_signoff FROM program_applications a WHERE e.id = a.program_enrollment_id;"
    execute "UPDATE program_enrollments e SET administrative_signoff = a.administrative_signoff FROM program_applications a WHERE e.id = a.program_enrollment_id;"
    remove_column :program_applications, :academic_signoff
    remove_column :program_applications, :administrative_signoff
    remove_column :program_applications, :interview_status
    remove_column :program_applications, :acceptance_status
  end
end
