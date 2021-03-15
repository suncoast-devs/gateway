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
  belongs_to :last_contact_disposition, class_name: "ContactDisposition", optional: true
  belongs_to :last_communication, class_name: "Communication", optional: true
  belongs_to :merged_person, class_name: "Person", optional: true

  delegate :current_program_acceptance, to: :current_program_enrollment, allow_nil: true

  phony_normalize :phone_number, default_country_code: "US", normalize_when_valid: true

  before_save :update_full_name

  # TODO: Eventually this will need to be refactored, if we offer more than one type of program.
  def current_program_enrollment
    program_enrollments.first
  end

  def to_liquid
    PersonDrop.new(self)
  end

  def attempt_contact!
    contact_dispositions.attempted.create! contacted_at: Time.now
  end

  def succeed_contact!
    contact_dispositions.succeeded.create! contacted_at: Time.now
  end

  private

  def update_full_name
    self.full_name ||= [given_name, middle_name, family_name].join(" ").squeeze(" ")
  end
end
