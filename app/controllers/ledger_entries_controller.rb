# frozen_string_literal: true
class LedgerEntriesController < ApplicationController
  before_action :find_person
  
  def index
    @ledger_entry = @person.ledger_entries.new
    @ledger_entries = @person.ledger_entries.order(created_at: :asc)
  end

  def create
    @ledger_entry = LedgerEntry.new(ledger_entry_params)

    if @ledger_entry.save
      redirect_to [@person, :ledger_entries], notice: 'Ledger Entry created.'
    else
      render :index
    end
  end

  private

  def find_person
    @person = Person.find(params[:person_id])
  end

   def ledger_entry_params
    params.require(:ledger_entry).permit(:person_id, :description, :amount)
  end
end
