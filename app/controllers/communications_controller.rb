# frozen_string_literal: true

class CommunicationsController < ApplicationController
  include Pagy::Backend
  layout false

  before_action :authenticate!
  before_action :find_person, only: %i[index new create]
  skip_before_action :verify_authenticity_token

  # Message Summaries & Threads
  def index
    if @person
      scope = @person.communications.order(messaged_at: :desc)
      @pagy, @records = pagy(scope)
      render 'thread'
    else
      @query = params[:q]
      scope =
        Person
          .left_outer_joins(:last_communication)
          .includes(:last_communication)
          .order(['last_communication_id IS NULL', 'communications.messaged_at DESC'])
      scope = scope.where('full_name ILIKE ?', "%#{@query}%") if @query.present?

      @pagy, @records = pagy(scope, items: 16)
      render 'summaries'
    end
  end

  # fully rendered email detail
  def show
    @communication = Communication.find(params[:id])

    if @communication.email?
      mail = Mail.new(@communication.data['mail'])
      render html: mail.body.decoded.html_safe, layout: false
    else
      render nothing: true
    end
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
