# frozen_string_literal: true

class CommunicationsController < ApplicationController
  include Pagy::Backend
  layout false

  before_action :authenticate!
  before_action :find_person, only: [:index, :new, :create]
  skip_before_action :verify_authenticity_token

  # Message Summaries & Threads
  def index
    if @person
      scope = @person.communications.order(messaged_at: :desc)
      @pagy, @records = pagy(scope)
      render "thread"
    else
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
    body = params[:body]
    if params[:is_sms]
    else
      subject = params[:subject]
      CreateOutboundEmailCommunication.call_later @person, subject, body
    end
    render json: { ok: true }
  end

  private

  def find_person
    @person = Person.find(params[:person_id]) if params[:person_id]
  end
end
