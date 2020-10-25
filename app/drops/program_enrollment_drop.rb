class ProgramEnrollmentDrop < Liquid::Drop
  
  delegate :program, :status_locator, :enrollment_agreement_complete?,
    :deposit_paid?, :deposit_required?, :deposit_unpaid_and_required?,
    to: :@program_enrollment, allow_nil: true
  
  def initialize(program_enrollment)
    @program_enrollment = program_enrollment
  end

  def program_name
    program.titleize
  end

  def deposit_invoice_url 
    @program_enrollment.deposit_invoice&.payment_url
  end

  def student_status_url
    Rails.application.routes.url_helpers.student_status_url status_locator
  end
end
