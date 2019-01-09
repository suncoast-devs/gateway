# frozen_string_literal: true

# The Person model represents a potential student, connected to a lead in the CRM
class Person < ApplicationRecord
  include Taggable

  has_many :invoices
  has_many :program_applications
  has_many :program_enrollments
  has_many :notes, as: :notable
  validates :full_name, presence: true
end
