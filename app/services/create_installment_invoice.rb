# frozen_string_literal: true

# Provides a service for doing nothing.
class CreateInstallmentInvoice
  include Callable

  def initialize(person)
    @person = person
  end

  def call
    if @person.ledger_balance.positive?
      amount = [@person.installment_amount, @person.ledger_balance].min
      description = "Installment payment toward remaining balance of $#{@person.ledger_balance}."
      invoice = @person.invoices.create(
          due_on: 14.days.from_now,
          invoice_items_attributes: [{ description:, quantity: 1, amount: }],
        )
      @person.update! installment_due_on: 21.days.from_now.next_month.beginning_of_month
      CreateInvoice.call(invoice.id)
    else
      @person.update! installment_amount: 0
    end
  end
end
