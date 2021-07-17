# frozen_string_literal: true
class SendLeadToClose
  include Callable

  def initialize(person)
    @person = person
  end

  def call
    # return unless Rails.env.production?
    if @person.close_lead.present?
      Close::API.put("lead/#{@person.close_lead}", lead_params)
      Close::API.put("lead/#{@person.close_contact}", contact_params) if @person.close_contact.present?
    else
      lead = Close::API.post('lead', create_lead_params)
      @person.update({ close_lead: lead['id'], close_contact: lead.dig('contacts', 0, 'id') }) if lead['id']
    end

    program_enrollment = @person.current_program_enrollment

    if program_enrollment.present?
      if program_enrollment.close_opportunity.present?
        Close::API.put("opportunity/#{program_enrollment.close_opportunity}", opportunity_params)
      else
        opportunity = Close::API.post('opportunity', create_opportunity_params)
        program_enrollment.update({ close_opportunity: opportunity['id'] }) if opportunity['id']
      end
    end
  end

  private

  def create_lead_params
    params = lead_params
    params['contacts'] = [contact_params]
    params
  end

  def contact_params
    { name: @person.full_name, emails: [{ email: @person.email_address }], phones: [{ phone: @person.phone_number }] }
  end

  def lead_params
    params = { "custom.#{Close::GATEWAY_FIELD}": @person.id, status_id: Close::LEAD_STATUS[@person.lead_status] }
    params["custom.#{Close::COHORT_FIELD}"] = @person.current_program_enrollment.cohort.name if @person
      .current_program_enrollment&.cohort
    params
  end

  def create_opportunity_params
    params = opportunity_params
    params['lead_id'] = @person.close_lead
    params
  end

  def opportunity_params
    program_enrollment = @person.current_program_enrollment
    status = Close::OPPORTUNITY_STATUSES[program_enrollment&.stage]
    params = { status_id: status, value: 14_900 * 100, value_period: 'one_time' }

    if %w[enrolled graduated dropped incomplete].includes? program_enrollment&.stage
      params['date_won'] = program_enrollment.cohort&.begins_on
    end

    params
  end
end
