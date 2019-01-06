# frozen_string_literal: true

# Provides a service for creating Invoices in stripe
class CreateInvoice
  include Callable

  def initialize(invoice_id)
    @invoice = Invoice.find(invoice_id)
  end

  def call
    return unless Rails.env.production?
    @invoice.invoice_items.each do |item|
      Stripe::InvoiceItem.create(
        unit_amount: (item.amount * 100).to_i,
        currency: "usd",
        customer: customer_id,
        quantity: item.quantity,
        description: item.description,
      )
    end
    invoice = Stripe::Invoice.create(
      customer: customer_id,
      billing: "send_invoice",
      due_date: @invoice.due_on.future? ? @invoice.due_on.to_time.to_i : 7.days.from_now.to_i,
    ).finalize_invoice
    @invoice.update(stripe_id: invoice.id, payment_url: invoice.hosted_invoice_url)
  end

  private

  def customer_id
    return @customer_id if @customer_id

    customers = Stripe::Customer.list(email: @invoice.person.email_address)
    @customer_id = if customers.data.empty?
                     Stripe::Customer.create(
                       email: @invoice.person.email_address,
                       description: @invoice.person.full_name,
                     ).id
                   else
                     customers.data.first.id
                   end
  end
end
