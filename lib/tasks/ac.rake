namespace :ac do
  desc "One-time push of active leads to AC"
  task export: :environment do
    ProgramEnrollment.where(status: 'active', cohort_id: 4).each do |enrollment|
      ConnectPersonToActiveCampaign.call(enrollment.person_id)
      ConnectProgramEnrollmentToActiveCampaign.call(enrollment.id)
    end
  end
end