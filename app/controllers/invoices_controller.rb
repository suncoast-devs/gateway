# frozen_string_literal: true

# Provides Invoices
class InvoicesController < ApplicationController
  include Pagy::Backend

  before_action :authenticate!
  before_action :find_invoice, only: [:show, :edit, :update, :destroy]

  def index
    scope = Invoice.order(created_at: :desc)
    @pagy, @invoices = pagy(scope)
  end

  def show; end

  def edit; end

  def new
    @person = Person.find(params[:person_id])
    @invoice = person.invoices.new
    @invoice.invoice_items.build
    @invoice.invoice_items.build
    # 2.times { @invoice.invoice_items.build }
  end

  def create
    @invoice = Invoice.new(invoice_params)

    if @invoice.save
      redirect_to @invoice, notice: "Invoice created."
    else
      render :new
    end
  end

  def update
    if @invoice.update(invoice_params)
      redirect_to @invoice, notice: "Invoice updated."
    else
      render :edit
    end
  end

  def destroy
    @invoice.destroy
    redirect_to invoices_path, notice: "Invoice destroyed."
  end

  private

  def find_invoice
    @invoice = Invoice.find(params[:id])
  end

  def invoice_params
    params.require(:invoice).permit(:person_id, :due_on)
  end
end
