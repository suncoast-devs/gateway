namespace :ac do
  desc "One-time push of active leads to AC"
  task export: :environment do
    ProgramEnrollment.where(status: "active", cohort_id: 4).each do |enrollment|
      ConnectPersonToActiveCampaign.call(enrollment.person_id)
      ConnectProgramEnrollmentToActiveCampaign.call(enrollment.id)
    end
  end

  task sync: :environment do
    list_ids = {
      prospects: "1",
      applicants: "2",
      lost: "3",
      alumni: "4",
      mailing: "5",
    }
    Person.all.each do |person|
      puts "Syncing #{person.full_name}"
      ConnectPersonToActiveCampaign.call(person.id)
      person.reload

      lists = [:mailing]

      enrollment = person.program_enrollments.first
      if enrollment
        lists << :lost if enrollment.lost?
        lists << :alumni if enrollment.won?
        lists << :applicants if enrollment.active?
      else
        lists << :prospects
      end

      lists.each do |list|
        puts "Adding to #{list} list."
        ActiveCampaign.post("contactLists",
                            contactList: {
                              list: list_ids[list],
                              contact: person.ac_contact_identifier,
                              status: "1",
                            })
      end
    end
  end
end
