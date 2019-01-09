# frozen_string_literal: true

# Provides a service for updating an enrollment in Gateway to ActiveCampaign
class SyncProgramEnrollmentToActiveCampaign
  include Callable

  AC_FIELD_IDS = {
    deposit_outstanding: "1",
    deposit_invoice_url: "2",
    sea_signed: "3",
    sea_sign_url: "4",
    financially_cleared: "5",
    cohort_start_date: "6",
    cohort_name: "7",
  }

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
    AC_FIELD_IDS.keys.each do |n|
      value = @program_enrollment.send "ac_#{n}_value"
      ac_field = @program_enrollment.send("ac_#{n}_field")
      data = {
        fieldValue: {
          contact: @program_enrollment.person.ac_contact_identifier,
          field: AC_FIELD_IDS[n],
          value: value,
        },
      }
      if ac_field
        # Update existing custom field datum
        ActiveCampaign.put("fieldValues/#{ac_field}", data)
      else
        # Create custom field datum
        response = ActiveCampaign.post("fieldValues", data)["fieldValue"]
        @program_enrollment.update("ac_#{n}_field": response["id"]) if response
      end
    end
  end

  private
end
