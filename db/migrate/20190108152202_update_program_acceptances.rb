class UpdateProgramAcceptances < ActiveRecord::Migration[5.2]
  def change
    remove_column :program_acceptances, :person_id
    remove_column :program_acceptances, :program_application_id
    add_column :program_acceptances, :enrollment_agreement_identifier, :string
    add_reference :program_enrollments, :deposit_invoice, foreign_key: {to_table: :invoices}

    ProgramAcceptance.reset_column_information
    ProgramEnrollment.reset_column_information
    ProgramAcceptance.all.each do |acceptance|
      identifier = acceptance.enrollment_agreement_url&.match(/\/document\/(\w+)-/)&.send(:[], 1)
      acceptance.update(enrollment_agreement_identifier: identifier)
      acceptance.program_enrollment&.update(deposit_invoice_id: acceptance.deposit_invoice_id)
    end

    remove_reference :program_acceptances, :deposit_invoice, foreign_key: {to_table: :invoices}
  end
end
