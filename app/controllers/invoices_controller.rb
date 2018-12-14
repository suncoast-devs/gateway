# frozen_string_literal: true

# Provides Invoices
class InvoicesController < ApplicationController
  include Pagy::Backend

  before_action :authenticate!

  def index
    scope = Invoice.order([is_paid: :desc, due_on: :asc])
    @pagy, @invoices = pagy(scope)
  end

  def show
    @invoice = Invoice.find(params[:id])
  end

  def new
    @person = Person.find(params[:person_id])
    @invoice = @person.invoices.new
    @invoice.invoice_items.build
  end

  def create
    @invoice = Invoice.new(invoice_params)
    @person = @invoice.person

    if @invoice.save
      redirect_to @invoice, notice: "Invoice created."
    else
      render :new
    end
  end

  private

  def invoice_params
    params.require(:invoice).permit(:person_id, :due_on, invoice_items_attributes: [:description, :quantity, :amount])
  end
end
