# frozen_string_literal: true

# Provides a service for updating an enrollment in Gateway to ActiveCampaign
class SyncProgramEnrollmentToActiveCampaign
  include Callable

  def initialize(program_enrollment_id)
    @program_enrollment = ProgramEnrollment.find(program_enrollment_id)
  end

  def call
    return unless Rails.env.production? && @program_enrollment.ac_deal_identifier
    ActiveCampaign.put("deals/#{@program_enrollment.ac_deal_identifier}",
                       deal: {
                         stage: ProgramEnrollment.stages[@program_enrollment.stage].to_s,
                         status: ProgramEnrollment.statuses[@program_enrollment.status].to_s,
                         title: "#{@program_enrollment.person.full_name} (Cohort #{@program_enrollment.cohort.name})",
                       })
    ActiveCampaign::FIELD_IDS.keys.each do |n|
      ActiveCampaign.post("fieldValues", {
        fieldValue: {
          contact: @program_enrollment.person.ac_contact_identifier,
          field: ActiveCampaign::FIELD_IDS[n],
          value: @program_enrollment.send("ac_#{n}_value"),
        },
      })
    end
  end

  private
end
