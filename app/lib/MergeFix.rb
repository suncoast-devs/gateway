# frozen_string_literal: true
module MergeFix
  def self.call(a, b)
    a = Person.find(a)
    b = Person.find(b)

    b.update(
      close_contact: a.close_contact.presence || b.close_contact,
      close_lead: a.close_lead.presence || b.close_lead,
    )

    a.update(close_contact: nil, close_lead: nil, discarded_at: Time.current)
    a.invoices.each { |o| o.update(person: b) }
    a.program_applications.each { |o| o.update(person: b) }
    a.program_enrollments.each { |o| o.update(person: b) }
    a.notes.each { |o| o.update(notable: b) }
    a.course_registrations.each { |o| o.update(person: b) }
    a.documents.each { |o| o.update(person: b) }
    a.contact_dispositions.each { |o| o.update(person: b) }
    a.communications.each { |o| o.update(person: b) }
  end
end
