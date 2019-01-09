namespace :sync do
  desc "One-time sync of Stripe invoices"
  task stripe: :environment do
    invoices = Stripe::Invoice.list
    invoices.auto_paging_each do |invoice|
      next if Invoice.where(stripe_id: invoice.id).first
      customer = Stripe::Customer.retrieve(invoice.customer)
      person = Person.where("lower(email_address) = ?", customer.email.downcase).first
      next unless person

      gateway_invoice = person.invoices.create({
        due_on: (Time.at(invoice.due_date).to_date rescue Date.today),
        is_paid: invoice.paid,
        stripe_id: invoice.id,
      })

      invoice.lines.each do |line|
        gateway_invoice.invoice_items.create({
          description: line.description, quantity: line.quantity, amount: line.amount / 100,
        })
      end

      if invoice.amount_due == 100000
        enrollement = person.program_enrollments.first
        if enrollement && !enrollement.deposit_invoice
          puts "Creating deposit invoice for #{customer.description}."
          enrollement.update(deposit_invoice: gateway_invoice)
        end
      end
    end
  end
end
