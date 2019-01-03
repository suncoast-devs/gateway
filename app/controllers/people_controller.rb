# frozen_string_literal: true

# Provides People
class PeopleController < ApplicationController
  include Pagy::Backend

  before_action :authenticate!
  before_action :find_person, only: [:show, :edit, :update, :destroy]

  def index
    @query = params[:q]
    scope = Person.order(created_at: :desc)
    scope = scope.where("full_name ILIKE ?", "%#{@query}%") if @query.present?

    if params[:t].present?
      @tag = Tag.find(params[:t])
      scope = scope.joins(:tags).merge(Tag.where(id: @tag.id))
    end

    @pagy, @people = pagy(scope)
  end

  def show; end

  def edit; end

  def new
    @person = Person.new
  end

  def create
    @person = Person.new(person_params)

    if @person.save
      redirect_to @person, notice: "#{@person.full_name} created."
    else
      render :new
    end
  end

  def update
    if @person.update(person_params)
      SyncCrmsJob.perform_later(@person.id)
      redirect_to @person, notice: "#{@person.full_name} updated."
    else
      render :edit
    end
  end

  def destroy; end

  private

  def find_person
    @person = Person.find(params[:id])
  end

  def person_params
    params.require(:person).permit(:full_name, :email_address, :phone_number, :source, :tag_list, :preferred_communication, :shirt_size, :dietary_note)
  end
end
