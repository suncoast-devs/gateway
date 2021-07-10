# frozen_string_literal: true
module Webhooks
  class Close
    include Callable

    def initialize(params)
      @params = params.with_indifferent_access
    end

    def event
      @event ||= JSON.parse(@params[:event].to_json, object_class: OpenStruct)
    end

    def event_method
      action = event.action
      object_type = event.object_type

      [object_type.parameterize.underscore, action].join('_')
    end

    def call
      if respond_to? event_method
        send event_method
      else
        raise 'Unhandled Close event'
      end
    end

    def opportunity_created
      # Noop, these should always be created by gateway first, not in close,
    end

    def opportunity_updated
      program_enrollment = ProgramEnrollment.where(close_opportunity: event.data.id).first
      if event.changed_fields.include? 'status_label'
        case event.data.status_label
        when 'Prospecting'
          # noop?
        when 'Applied'
          program_enrollment.applied!
        when 'Interviewing'
          program_enrollment.interviewing!
        when 'Accepted'
          program_enrollment.accepted!
        when 'Enrolling'
          program_enrollment.enrolling!
        when 'Enrolled'
          program_enrollment.won!
          program_enrollment.enrolled!
        when 'Lost'
          program_enrollment.lost!
        end
      end
    end

    def opportunity_deleted
      program_enrollment = ProgramEnrollment.where(close_opportunity: event.previous_data.id).first
      program_enrollment.discard if program_enrollment.present?
    end

    def activity_note_created
      user = User.where(close_user: event.data.user_id).first
      person = Person.where(close_lead: event.data.lead_id).first
      person.notes.create!({ user: user, note_type: 'comment', message: event.data.note, close_note: event.data.id })
    end

    def activity_note_updated
      note = Note.where(close_note: event.data.id).first
      note.update(message: event.data.note)
    end

    def activity_note_deleted
      note = Note.where(close_note: event.previous_data.id).first
      note.discard
    end

    def lead_created
      # noop?
    end

    def lead_updated
      person = Person.where(close_lead: event.data.id).first
      person.full_name = event.data.name if event.changed_fields.include? 'name'

      if person.current_program_enrollment.present?
        if event.changed_fields.include? "custom.#{::Close::COHORT_FIELD}"
          cohort_name =
            @params.dig(:event, :data, 'custom.lcf_c6w_g4_hg_xp_r_wz455_s_dezi3e_hi_n_na_r_mdty_r_uf_go_o5a_ziz', 0)
          cohort = Cohort.where(name: cohort_name).first
          person.current_program_enrollment.update(cohort: cohort) if cohort
        end

        if event.changed_fields.include? 'status_label'
          case event.data.status_label
          when 'Bad Fit', 'Not Interested'
            person.current_program_enrollment.lost!
          when 'Canceled'
            person.current_program_enrollment.canceled!
          when 'Potential'
            person.current_program_enrollment.active!
          when 'Qualified'
            person.current_program_enrollment.active!
          when 'Interested'
            person.current_program_enrollment.active!
          when 'Customer'
            person.current_program_enrollment.won!
          end

          # Send any changes here back to close (to update the opportunity).
          SendLeadToClose.call_later(person)
        end
      end

      person.save
    end

    def lead_deleted
      person = Person.where(close_lead: event.previous_data.id).first
      person.discard if person.present?
    end

    def lead_merged
      source_person = Person.where(close_lead: event.meta.merge_source_lead_id).first
      person = Person.where(close_lead: event.meta.merge_destination_lead_id).first
      source_person.update(merged_person: person)
    end

    def contact_created
      person = Person.where(close_contact: event.data.id).first || Person.new
      person.close_contact = event.data.id
      person.close_lead = event.data.lead_id
      person.full_name = event.data.name
      person.email_address = event.data.emails.first&.email
      person.phone_number = event.data.phones.first&.phone
      person.save
    end

    def contact_updated
      person = Person.where(close_contact: event.data.id).first
      person.full_name = event.data.name if event.changed_fields.include? 'name'
      person.email_address = event.data.emails.first.email if event.changed_fields.include? 'emails'
      person.phone_number = event.data.phones.first.phone if event.changed_fields.include? 'phones'
      person.save
    end

    def contact_deleted
      person = Person.where(close_contact: event.previous_data.id).first
      person.discard if person.present?
    end
  end
end
