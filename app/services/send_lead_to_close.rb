class SendLeadToClose
  include Callable

  OPPORTUNITY_STATUSES = {
    "Prospecting" => "stat_OOgm0jrlEm2mqrWucE3PDZ7C1l3hlflP7Fw7XqHwYV5",
    "Applied" => "stat_rB8EiNbRIV70Nc3SO3HRaLLdOFJHJeTQufYmxIYuktj",
    "Interviewing" => "stat_B9abaIrzJiyscia4qjqj7QEz5f1YntugaqpsDNAQEtT",
    "Accepted" => "stat_7F9vBDgfjSnpvOJNhkTnDBRNXUVwWPoeQSahXnnbCyD",
    "Enrolling" => "stat_gPRErfel5Kb0eh6LMXovSRGuHKPQo9bVuzdah51cIz0",
    "Enrolled" => "stat_sPqxIBPp8iplX0wLWjDAKNDw4du3IHVJaqRWk6Z4WVJ",
    "Lost" => "stat_6fvDD2ISHy6w3kzxVB3NM0UKbiVJikBn1yt40HkUaok",
  }

  LEAD_STATUS = {
    "Bad Fit" => "stat_1s0UWUp7U3NO1Mo6YqoNjVHDcw5jMNsQnUD7bxxxxv0",
    "Not Interested" => "stat_31t9JRMiyi7GIO2iFxcMJO9juOaQfJmInvRHPyGRfNp",
    "Customer" => "stat_5d0G6jkwBM0e1UmqXkI3FRrFKv40g24xM5ZKN89xrC8",
    "Potential" => "stat_6IUBThmVFaUiEyTFW7gBYHtMjJgb5ySjRGwZfeupLEF",
    "Canceled" => "stat_jHSETcjN10b4jp97qqLQ5eZzuVBNHSRFL0z28QmfAiJ",
    "Qualified" => "stat_qYgHF9vQEiGg4PNEaFTDIVTz3yDpWcrUk3hD4ERQpyZ",
    "Interested" => "stat_y3sOe1xIkYbxorAI3vlBdbHtKHHZiFj5AiFrXJCAjk4",
  }

  COHORT_FIELD = "lcf_C6wG4HgXpRWz455SDezi3eHiNNaRMdtyRUfGoO5aZIZ"
  GATEWAY_FIELD = "lcf_GD5hdf9Z4k5poQVTw7wrbRe1ogeZgDxFJwxFjG6II1g"

  def initialize(person)
    @person = person
  end

  def call
    # return unless Rails.env.production?
    unless @person.close_lead.present?
      lead = CloseAPI.post("lead", create_lead_params)
      if lead["id"]
        @person.update({
          close_lead: lead["id"],
          close_contact: lead.dig("contacts", 0, "id"),
        })
        if @person.current_program_enrollment
          opportunity = CloseAPI.post("opportunity", create_opportunity_params)
          if opportunity["id"]
            @person.current_program_enrollment.update({
              close_opportunity: opportunity["id"],
            })
          end
        end
      end
    else
      CloseAPI.put("lead/#{@person.close_lead}", update_lead_params)
      CloseAPI.put("contact/#{@person.close_contact}", update_contact_params)
      CloseAPI.put("opportunity/#{@person.current_program_enrollment.close_opportunity}", update_opportunity_params)
    end
  end

  private

  def create_lead_params
    params = update_lead_params
    params["contacts"] = [update_contact_params]
    params
  end

  def create_opportunity_params
    params = update_opportunity_params
    params["lead_id"] = @person.close_lead
    params
  end

  def update_lead_params
    params = {
      "status_id": LEAD_STATUS[status_keys.last],
      "custom.#{GATEWAY_FIELD}": @person.id,
    }

    if @person.current_program_enrollment
      params["custom.#{COHORT_FIELD}"] = @person.current_program_enrollment.cohort.name
    end

    params
  end

  def update_contact_params
    {
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
    }
  end

  def update_opportunity_params
    status = OPPORTUNITY_STATUSES[status_keys.first]
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
