# Applicant   *Accepted
# Applicant   *Applied
# Won         *Enrolled
# Applicant   *Enrolling
# Applicant   *Interviewed
# Pending     *Prospect
# Pending     *Qualified
# Applicant   *Set Interview
# Won         *Verified Enrollment
# Lost        Accepted - Do Not Call
# Lost        Accepted - Not Interested
# Won         Alum
# Lost        Application Withdrawn
# Lost        Applied - Do Not Call
# Lost        Applied - Not Interested
# Lost        Dropped
# Lost        Enrolling - Do Not Call
# Lost        Enrolling - Not Interested
# Lost        Enrollment Withdrawn
# Lost        Interviewed - Do Not Call
# Lost        Interviewed - Not Interested
# Applicant   No Show
# Lost        Prospect - Do Not Call
# Lost        Prospect - Not Interested
# Lost        Prospect - Not Qualified
# Pending     Re-Inquiry
# Lost        Rejected
# Lost        Set Interview - Do Not Call
# Lost        Set Interview - Not Interested
# Unknown     Unknown

def lead_status(program_enrollment)
"*Accepted"
"*Applied"
"*Enrolled"
"*Enrolling"
"*Interviewed"
"*Prospect"
"*Qualified"
"*Set Interview"
"*Verified Enrollment"
"Accepted - Do Not Call"
"Accepted - Not Interested"
"Alum"
"Application Withdrawn"
"Applied - Do Not Call"
"Applied - Not Interested"
"Dropped"
"Enrolling - Do Not Call"
"Enrolling - Not Interested"
"Enrollment Withdrawn"
"Interviewed - Do Not Call"
"Interviewed - Not Interested"
"No Show"
"Prospect - Do Not Call"
"Prospect - Not Interested"
"Prospect - Not Qualified"
"Re-Inquiry"
"Rejected"
"Set Interview - Do Not Call"
"Set Interview - Not Interested"
"Unknown"
end

namespace :verity do
  task export: :environment do    
    CSV.open("verity-export.csv", "wb") do |csv|
      csv << [
        "SchoolName", "CampusName", "SchoolID", "FirstName", "LastName", "MI", "Gender", "Salutation",
        "LeadStatus", "LeadSourceCategory", "LeadSource", "OptIn",
        "Email 1 Type", "Email 1", "Email 2 Type", "Email 2",
        "Phone 1 Type", "Phone 1", "Phone 2 Type", "Phone 2",
        "Program Code", "ProgramOfInterest",
        "TermStartOfInterest", "LeadDateTime", "AdmissionsAdvisor",
        "Address", "City", "State", "Province", "Zip", "Country",
        "Ethnicity", "Citizenship", "Nationality", "EmploymentStatus", "HighSchoolGradYR", "DateOfBirth"
      ]

      Person.all.each do |person|
        given_name, family_name = FullNameSplitter.split(person.full_name)
        program_enrollment = person.program_enrollments.first
        cohort = program_enrollment&.cohort
        csv << [
          "Suncoast Developers Guild", "St. Petersburg", "GW-#{person.id}", given_name, family_name, nil, nil, nil,
          program_enrollment ? "#{program_enrollment.status}/#{program_enrollment.stage}" : "none", "Legacy", person.source&.titleize, "Yes",
          "Home", person.email_address, nil, nil,
          "Mobile", person.phone_number, nil, nil,
          program_enrollment && "WD", program_enrollment && "Web Development Program",
          cohort&.begins_on&.strftime("%d/%m/%Y"), person.created_at.strftime("%d/%m/%Y"), "Kento Kawakami",
          nil, nil, nil, nil, nil, nil,
          nil, nil, nil, nil, nil, nil
        ]
      end
    end    
  end
end
