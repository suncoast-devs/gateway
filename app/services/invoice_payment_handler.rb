# frozen_string_literal: true

class InvoicePaymentHandler
  include Callable

  def initialize(invoice)
    @invoice = invoice
  end

  def call
    @invoice.update is_paid: true
    @program_enrollment = ProgramEnrollment.where(deposit_invoice: @invoice).first
    if @program_enrollment
      @program_enrollment.update(deposit_paid: true)
      CommunicationTemplate.by_key('deposit-paid')&.send_to(@program_enrollment.person)
    end
  end
end
