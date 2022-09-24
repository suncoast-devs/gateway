# frozen_string_literal: true

class InvoiceInstallmentsJob < ApplicationJob
  queue_as :default

  def perform
    Person.where("installment_due_on <=": Time.zone.today, "installment_amount >": 0).each do |person|
      CreateInstallmentInvoice.call_later(person)
    end
  end
end
