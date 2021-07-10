# frozen_string_literal: true
module Webhooks
  class Postmark
    include Callable

    attr_reader :params

    def initialize(params)
      @params = params.with_indifferent_access
    end

    def call
      @program_acceptance = ProgramAcceptance.where(message_id: params[:MessageID]).first
      if @program_acceptance
        note = case params[:RecordType]
          when 'Delivery' then "Acceptance email delivered to #{params[:Recipient]}."
          when 'Bounce' then "Acceptance email not delivered to #{params[:Recipient]}.\n\n> #{params[:Description]}"
          when 'SpamComplaint' then "Acceptance email to #{params[:Recipient]} flagged as spam."
          when 'Open' then 'Acceptance email opened.'
          when 'Click' then 'Link clicked in acceptance email.'
          end
        @program_acceptance.person.notes.create note_type: 'email-event', message: note, data: params
      end
    end
  end
end
