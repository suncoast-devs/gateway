# frozen_string_literal: true

# The Person model represents a potential student
class Person < ApplicationRecord
  include Taggable
  include Discard::Model

  has_many :invoices
  has_many :program_applications
  has_many :program_enrollments
  has_many :notes, as: :notable
  has_many :course_registrations
  has_many :documents
  has_many :contact_dispositions
  has_many :communications
  has_many :social_links
  has_many :employment_records
  has_many :ledger_entries
  belongs_to :last_contact_disposition, class_name: 'ContactDisposition', optional: true
  belongs_to :last_communication, class_name: 'Communication', optional: true
  belongs_to :merged_person, class_name: 'Person', optional: true

  enum lead_status: {potential: 0, interested: 1, qualified: 2, bad_fit: 3, customer: 4, 
uninterested: 5, irrelevant: 6}

  delegate :current_program_acceptance, to: :current_program_enrollment, allow_nil: true

  phony_normalize :phone_number, default_country_code: 'US', normalize_when_valid: true
  phony_normalize :emergency_contact_phone_number, default_country_code: 'US', normalize_when_valid: true

  before_save :update_full_name

  # TODO: Eventually this will need to be refactored, if we offer more than one type of program.
  def current_program_enrollment
    program_enrollments.first
  end

  def to_liquid
    PersonDrop.new(self)
  end

  def attempt_contact!
    contact_dispositions.attempted.create! contacted_at: Time.zone.now
  end

  def succeed_contact!
    contact_dispositions.succeeded.create! contacted_at: Time.zone.now
  end

  def ledger_balance
    @ledger_balance ||= ledger_entries.sum(:amount)
  end

  private

  def update_full_name
    self.full_name ||= [given_name, middle_name, family_name].join(' ').squeeze(' ')
  end
end
