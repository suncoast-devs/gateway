# frozen_string_literal: true

# Provides a service for accepting students into the web development program.
class CreateProgramAcceptance
  include Callable

  def initialize(program_acceptance_id)
    @program_acceptance = ProgramAcceptance.find(program_acceptance_id)
    @cohort = @program_acceptance.cohort
    @person = @program_acceptance.person
  end

  def call
    # :due_on, invoice_items_attributes: [:description, :quantity, :amount]
    due_date = [@cohort.begins_on - 7.days, 1.day.from_now].max
    @invoice = @person.invoices.create(due_on: due_date,
                                       invoice_items_attributes: [
                                         { description: 'Tuition Deposit', quantity: 1, amount: 1000 }
                                       ])
    CreateInvoice.call(@invoice.id)
    @invoice.reload
    @program_acceptance.update(deposit_invoice: @invoice,
                               notification_body: notification_template)

  end

  private

  def notification_template
    <<~TEMPLATE
      Welcome to Cohort #{@cohort.name}!

      [Pay your deposit](#{@invoice.payment_url})
    TEMPLATE
  end
end
