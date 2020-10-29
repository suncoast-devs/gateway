# frozen_string_literal: true

class CommunicationsController < ApplicationController
  include Pagy::Backend
  layout false

  before_action :authenticate!
  before_action :find_person, only: [:index, :new, :create]

  # Message Summaries & Threads
  def index
    if @person # Thread
    else # Summaries
      scope = Person.joins(:last_communication).includes(:last_communication).order('communications.messaged_at': "desc").where.not(last_communication_id: nil)
      @pagy, @records = pagy(scope)

      render "summaries"
    end
  end

  # fully rendered email detail
  def show
  end

  # preview template
  def new
  end

  # send message
  def create
  end

  # mark read/unread
  def update
  end

  private

  def find_person
    @person = Person.where(params[:person_id]).first if params[:person_id]
  end
end
