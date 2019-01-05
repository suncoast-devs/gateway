# frozen_string_literal: true

# Provides a service for connecting an enrollment in Gateway to ActiveCampaign
class ConnectProgramEnrollmentToActiveCampaign
  include Callable

  def initialize(program_enrollment_id)
    @program_enrollment = ProgramEnrollment.find(program_enrollment_id)
  end

  def call
    return unless Rails.env.production?
    @program_enrollment.update ac_deal_identifier: deal["id"] unless @program_enrollment.ac_deal_identifier
  end

  private

  def deal
    @deal ||= begin
      person = @program_enrollment.person
      ActiveCampaign.post("deals",
                          deal: {
                            contact: person.ac_contact_identifier,
                            currency: "usd",
                            group: "1", # Web Development Program
                            stage: ProgramEnrollment.stages[@program_enrollment.stage].to_s,
                            status: 0,
                            title: "#{person.full_name} (Cohort #{@program_enrollment.cohort.name})",
                            value: 14_900 * 100,
                          })["deal"]
    end
  end
end
