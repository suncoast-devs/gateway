# frozen_string_literal: true

# Provides a service for updating an enrollment in Gateway to ActiveCampaign
class SyncProgramEnrollmentToActiveCampaign
  include Callable

  def initialize(program_enrollment_id)
    @program_enrollment = ProgramEnrollment.find(program_enrollment_id)
  end

  def call
    return unless Rails.env.production?
    ActiveCampaign.put("deals/#{@program_enrollment.ac_deal_identifier}",
                       deal: {
                         stage: ProgramEnrollment.stages[@program_enrollment.stage].to_s,
                         status: ProgramEnrollment.statuses[@program_enrollment.status].to_s,
                         title: "#{person.full_name} (Cohort #{@program_enrollment.cohort.name})",
                       })
  end

  private
end
