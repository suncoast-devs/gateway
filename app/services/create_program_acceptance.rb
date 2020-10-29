# frozen_string_literal: true

# Provides a service for accepting students into the web development program.
class CreateProgramAcceptance
  include Callable

  def initialize(program_acceptance)
    @program_acceptance = program_acceptance
    @program_enrollment = @program_acceptance.program_enrollment
    @cohort = @program_acceptance.cohort
    @person = @program_acceptance.person
  end

  def call
    unless @program_acceptance.enrollment_agreement_url.present?
      CreateEnrollmentAgreement.call(@program_acceptance)
      @program_acceptance.reload
    end

    unless @program_enrollment.deposit_invoice.present?
      # Deposit Invoice
      due_date = [@cohort.tuition_due_date, 1.day.from_now].max
      @invoice = @person.invoices.create(due_on: due_date,
                                         invoice_items_attributes: [
                                           {description: "Tuition Deposit", quantity: 1, amount: 1000},
                                         ])
      CreateInvoice.call(@invoice.id)
      @invoice.reload
      @program_enrollment.update(deposit_invoice: @invoice)
    else
      @invoice = @program_enrollment.deposit_invoice
    end
    
    mail = CommunicationTemplate.by_key('acceptance-letter')&.send_to(@person)
    @program_acceptance.update sent_at: Time.now, message_id: mail.message_id
    @program_enrollment.accepted!
  end
end
