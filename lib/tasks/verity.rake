namespace :verity do
  task export: :environment do    
    CSV.open("verity-export.csv", "wb") do |csv|
      csv << [
        "SchoolName", "CampusName", "SchoolID", "FirstName", "LastName", "MI", "Gender", "Salutation",
        "LeadStatus", "LeadSourceCategory", "LeadSource", "OptIn",
        "Email 1 Type", "Email 1", "Email 2 Type", "Email 2", "Phone 1 Type", "Phone 1", "Phone 2 Type", "Phone 2",
        "Program Code", "ProgramOfInterest", "TermStartOfInterest", "LeadDateTime", "AdmissionsAdvisor",
        "Address", "City", "State", "Province", "Zip", "Country",
        "Ethnicity", "Citizenship", "Nationality", "EmploymentStatus", "HighSchoolGradYR", "DateOfBirth"
      ]

      Person.all.each do |person|
        given_name, family_name = FullNameSplitter.split(person.full_name)
        program_enrollment = person.program_enrollments.first
        cohort = program_enrollment&.cohort
        csv << [
          "Suncoast Developers Guild", "St. Petersburg", given_name, family_name, nil, nil, nil,
          program_enrollment&.status || "none", "Legacy", person.source&.titleize, "Yes",
          "Home", person.email_address, nil, nil,
          "Home", person.phone_number, nil, nil,
          program_enrollment && "WD", program_enrollment && "Web Development Program", cohort&.begins_on&.strftime("%d/%m/%Y"), person.created_at.strftime("%d/%m/%Y"), "Kento Kawakami",
          nil, nil, nil, nil, nil, nil,
          nil, nil, nil, nil, nil, nil
        ]
      end
    end    
  end
end
