# frozen_string_literal: true

# Provides People
class PeopleController < ApplicationController
  include Pagy::Backend

  before_action :authenticate!
  before_action :find_person, only: %i[show edit update destroy]

  def index
    @query = params[:q]
    scope = Person.order(created_at: :desc)
    scope = params[:all] ? scope.all : scope.kept
    scope = scope.where('full_name ILIKE ?', "%#{@query}%") if @query.present?

    if params[:t].present?
      @tag = Tag.find(params[:t])
      scope = scope.joins(:tags).merge(Tag.where(id: @tag.id))
    end

    @pagy, @people = pagy(scope)
  end

  def show
  end

  def new
    @person = Person.new
  end

  def edit
  end

  def create
    @person = Person.new(person_params)

    if @person.save
      SendLeadToClose.call_later(@person)
      redirect_to @person, notice: "#{@person.full_name} created."
    else
      render :new
    end
  end

  def update
    if @person.update(person_params)
      SendLeadToClose.call_later(@person)
      redirect_to @person, notice: "#{@person.full_name} updated."
    else
      render :edit
    end
  end

  def destroy
    if @person.discarded?
      @person.undiscard!
    else
      @person.update(close_lead: nil, close_contact: nil)
      @person.discard
    end

    redirect_back(fallback_location: @person, notice: "#{@person.full_name} discarded.")
  end

  private

  def find_person
    @person = Person.find(params[:id])
  end

  def person_params
    params
      .require(:person)
      .permit(
        :given_name,
        :family_name,
        :full_name,
        :email_address,
        :phone_number,
        :source,
        :preferred_communication,
        :shirt_size,
        :dietary_note,
        :close_lead,
        :close_contact,
        :installment_amount,
      )
  end
end
