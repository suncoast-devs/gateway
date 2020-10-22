# frozen_string_literal: true

# The Person model represents a potential student
class Person < ApplicationRecord
  include Taggable

  has_many :invoices
  has_many :program_applications
  has_many :program_enrollments
  has_many :notes, as: :notable
  has_many :course_registrations
  has_many :contact_dispositions
  belongs_to :last_contact_disposition, class_name: 'ContactDisposition', optional: true

  before_save :update_full_name
 
  private

  def update_full_name
    self.full_name = [given_name, middle_name, family_name].join(' ').squeeze(' ')
  end
end
