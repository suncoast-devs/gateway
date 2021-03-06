class SendLeadToClose
  include Callable

  def initialize(person)
    @person = person
  end

  def call
    # return unless Rails.env.production?
    unless @person.close_lead.present?
      lead = Close::API.post("lead", create_lead_params)
      if lead["id"]
        @person.update({
          close_lead: lead["id"],
          close_contact: lead.dig("contacts", 0, "id"),
        })
      end
    end

    if @person.current_program_enrollment
      if @person.current_program_enrollment.close_opportunity.present?
        Close::API.put("opportunity/#{@person.current_program_enrollment.close_opportunity}", update_opportunity_params)
      else
        opportunity = Close::API.post("opportunity", create_opportunity_params)
        if opportunity["id"]
          @person.current_program_enrollment.update({
            close_opportunity: opportunity["id"],
          })
        end
      end
    end
  end

  private

  def create_lead_params
    params = {
      "custom.#{Close::GATEWAY_FIELD}": @person.id,
      "status_id": Close::LEAD_STATUS[status_keys.last],
      "contacts": {
        "name": @person.full_name,
        "emails": [
          {
            "email": @person.email_address,
          },
        ],
        "phones": [
          {
            "phone": @person.phone_number,
          },
        ],
      },
    }
    if @person.current_program_enrollment && @person.current_program_enrollment.cohort
      params["custom.#{Close::COHORT_FIELD}"] = @person.current_program_enrollment.cohort.name
    end
    params
  end

  def create_opportunity_params
    params = update_opportunity_params
    params["lead_id"] = @person.close_lead
    params
  end

  def update_opportunity_params
    status = Close::OPPORTUNITY_STATUSES[status_keys.first]
    params = {
      "status_id": status,
      "value": 14_900 * 100,
      "value_period": "one_time",
    }

    if status == "Enrolled" && @person.current_program_enrollment
      params["date_won"] = @person.current_program_enrollment.cohort&.begins_on
    end

    params
  end

  def status_keys
    pe = @person.current_program_enrollment
    return ["Prospecting", "Potential"] unless pe

    if pe.active?
      case pe.stage
      when "applied" then return ["Applied", "Interested"]
      when "interviewing" then return ["Interviewing", "Interested"]
      when "accepted" then return ["Accepted", "Qualified"]
      when "enrolling" then return ["Enrolling", "Qualified"]
      when "enrolled" then return ["Enrolling", "Qualified"]
      else return ["Prospecting", "Potential"]
      end
    elsif pe.won?
      return ["Enrolled", "Customer"]
    elsif pe.lost?
      case pe.stage
      when "applied" then return ["Lost", "Interested"]
      when "interviewing" then return ["Lost", "Interested"]
      when "accepted" then return ["Lost", "Qualified"]
      when "enrolling" then return ["Lost", "Qualified"]
      when "enrolled" then return ["Lost", "Qualified"]
      else return ["Lost", "Potential"]
      end
    end
    return ["Prospecting", "Potential"]
  end
end
