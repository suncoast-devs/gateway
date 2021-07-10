# frozen_string_literal: true
STATUS = {0 => 'active', 1 => 'pending', 10 => 'won', 11 => 'lost', 12 => 'cancelled'}.freeze

STAGES = {'student' => 'enrolled', 'alumni' => 'enrolled', 'prospecting' => 'applied', 'qualified' => 'applied'}.freeze

COHORTS = {
  nil => 'Future',
  false => 'Future',
  'Unknown' => 'Future',
  'Future' => 'Future',
  'Cohort PROforma (Mar 2018)' => 'Proforma',
  'Cohort X (Jul 2018)' => 'X',
  'Cohort XI (Sep 2018)' => 'XI',
  'Cohort XII (Oct 2018)' => 'XII',
  'Cohort XIII (Jan 2019)' => 'XIII',
  'Cohort XIV (April 2019)' => 'XIV',
  'Cohort XV (July 2019)' => 'XIV',
  'Cohort XVI (October 2019)' => 'Future',
}.freeze

namespace :nutshell do
  desc 'One-time sync of data from Nutshell to Gateway'
  task sync: :environment do
    nutshell = Nutshell.client
    leads = nutshell.find_leads({filter: 2}, nil, nil, 500)
    leads.each.with_index do |stub, _i|
      lead = nutshell.get_lead(stub['id'])
      next unless lead['contacts'][0]
      contact = nutshell.get_contact(lead['contacts'][0]['id'])
      next unless contact['email']

      name = stub['primaryContactName']
      email = contact['email']['--primary']
      phone = contact['phone'] && contact['phone']['--primary']['numberFormatted'] || nil
      cohort = COHORTS[lead['customFields'] && lead['customFields']['Cohort']]
      stage = STAGES[lead['milestone']['name'].downcase] || lead['milestone']['name'].downcase
      status = STATUS[lead['status']]
      lost_reason = (lead['status'] == 11 && lead['outcome']['description']) || nil
      deposit_paid = lead['customFields'] && lead['customFields']['Deposit'] == 'Paid' || false
      enrollment_agreement_complete = lead['customFields'] && lead['customFields']['Enrollment Agreement'] == 'Signed' || false
      financial_clearance = lead['customFields'] && lead['customFields']['Financially Cleared'] || nil
      referrer = lead['customFields'] && lead['customFields']['Referrer'] || nil
      preferred_communication = (lead['customFields'] && lead['customFields']['Preferred Communication']) || (contact['customFields'] && contact['customFields']['Preferred Communication']) || nil
      shirt_size = contact['customFields'] && contact['customFields']['Shirt Size'] || nil
      dietary_note = contact['customFields'] && contact['customFields']['Dietary Note'] || nil
      tag_list = (contact['tags'] + lead['tags']).uniq.join(', ')
      source = !lead['sources'].empty? && lead['sources'].first['name'].parameterize || nil
      notes = (contact['notes'] + lead['notes']).map do |n|
 [n['user'] && n['user']['emails'].first || nil, n['noteMarkup']] end

      puts "Syncing #{name}..."

      person = Person.where('lower(email_address) = ?', email.downcase).first_or_initialize do |person|
        person.email_address ||= email
        person.full_name ||= name
        person.phone_number = phone
        person.source ||= source
        person.tag_list = tag_list
        person.shirt_size = shirt_size
        person.dietary_note = dietary_note
        person.preferred_communication = preferred_communication
        person.save!
      end

      enrollment = person.program_enrollments.first

      if enrollment
        enrollment.cohort = Cohort.where(name: cohort).first
        enrollment.stage = stage
        enrollment.status = status
        enrollment.lost_reason = lost_reason
        enrollment.deposit_paid = deposit_paid
        enrollment.enrollment_agreement_complete = enrollment_agreement_complete
        enrollment.financial_clearance = financial_clearance
        enrollment.referrer = referrer
        enrollment.save!
      else
        puts "No enrollment for #{name}."
      end
    end
  end
end
