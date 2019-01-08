# frozen_string_literal: true

# Provides a service for updating an enrollment in Gateway to ActiveCampaign
class SyncProgramEnrollmentToActiveCampaign
  include Callable

  AC_FIELD_IDS = {
    deposit_outstanding: "2",
    enrollment_agreement_signed: "3",
    financially_cleared: "4",
    deposit_invoice_url: "5",
    enrollment_agreement_url: "6",
  }

  def initialize(program_enrollment_id)
    @program_enrollment = ProgramEnrollment.find(program_enrollment_id)
  end

  def call
    return unless Rails.env.production?
    ActiveCampaign.put("deals/#{@program_enrollment.ac_deal_identifier}",
                       deal: {
                         stage: ProgramEnrollment.stages[@program_enrollment.stage].to_s,
                         status: ProgramEnrollment.statuses[@program_enrollment.status].to_s,
                         title: "#{@program_enrollment.person.full_name} (Cohort #{@program_enrollment.cohort.name})",
                       })
    %i[
      deposit_outstanding deposit_invoice_url
      enrollment_agreement_signed financially_cleared
      enrollment_agreement_url
    ].each do |n|
      value = @program_enrollment.send "ac_#{n}_value"
      ac_field = @program_enrollment.send("ac_#{n}_field")
      if ac_field
        # Update existing custom field datum
        ActiveCampaign.put("dealCustomFieldData/#{ac_field}", {
          dealCustomFieldDatum: {
            fieldValue: value,
          },
        })
      else
        # Create custom field datum
        response = ActiveCampaign.post("dealCustomFieldData", {
          dealCustomFieldDatum: {
            dealId: @program_enrollment.ac_deal_identifier,
            custom_field_id: AC_FIELD_IDS[n],
            fieldValue: value,
          },
        })
        if response["dealCustomFieldDatum"]
          @program_enrollment.update("ac_#{n}_field": response["dealCustomFieldDatum"]["id"])
        end
      end
    end
  end

  private
end
