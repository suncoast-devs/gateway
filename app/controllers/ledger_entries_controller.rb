# frozen_string_literal: true
class LedgerEntriesController < ApplicationController
  before_action :find_person
  before_action :find_ledger_entry, only: [:edit, :update, :destroy]
  
  def index
    @ledger_entry = @person.ledger_entries.new
    @ledger_entries = @person.ledger_entries.order(created_at: :asc)
  end

  def edit
  end

  def create
    @ledger_entry = LedgerEntry.new(ledger_entry_params)

    if @ledger_entry.save
      redirect_to [@person, :ledger_entries], notice: 'Ledger Entry created.'
    else
      render :index
    end
  end

  def update
    if @ledger_entry.update(ledger_entry_params)
      redirect_to [@person, :ledger_entries], notice: 'Ledger Entry updated.'
    else
      render :edit
    end
  end

  def destroy
    @ledger_entry.destroy
    redirect_to [@person, :ledger_entries], notice: 'Ledger Entry removed.'
  end

  private

  def find_person
    @person = Person.find(params[:person_id])
  end

  def find_ledger_entry
    @ledger_entry = LedgerEntry.find(params[:id])
  end

  def ledger_entry_params
    params.require(:ledger_entry).permit(:person_id, :description, :amount, :created_at)
  end
end
