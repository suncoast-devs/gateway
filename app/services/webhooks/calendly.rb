module Webhooks
  # https://developer.calendly.com/docs/webhook-subscriptions
  class Calendly
    include Callable

    def initialize(params)
      @params = params.with_indifferent_access
    end

    def call
      case @params[:event]
      when "invitee.created"
        calendar_event = CalendarEvent.find_or_create_by(uuid: @params.dig(:payload, :event, :uuid)) do |event|
          event.person = Person.where(email_address: @params.dig(:payload, :invitee, :email)).first
          event.name = [@params.dig(:payload, :event_type, :name), @params.dig(:payload, :invitee, :name)].join(' with ')
          event.starts_at = @params.dig(:payload, :event, :start_time)
          event.ends_at = @params.dig(:payload, :event, :end_time)
          event.is_canceled = @params.dig(:payload, :event, :canceled)
          event.data = @params
        end
        ActiveSupport::Notifications.instrument "interview_scheduled.gateway", [calendar_event]
      when "invitee.canceled"
        calendar_event = CalendarEvent.find_by(uuid: @params.dig(:payload, :event, :uuid))
        calendar_event.update is_canceled: @params.dig(:payload, :event, :canceled)
        ActiveSupport::Notifications.instrument "interview_canceled.gateway", [calendar_event]
      end
    end
  end
end
