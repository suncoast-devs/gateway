# frozen_string_literal: true

# The Person model represents a potential student, connected to a lead in the CRM
class Person < ApplicationRecord
  include Taggable

  has_many :invoices
  has_many :program_applications
  has_many :program_enrollments
  has_many :notes, as: :notable
  has_many :course_registrations

  before_create :update_full_name
 
  private

  def update_full_name
    if full_name.blank?
      self.full_name = [given_name, middle_name, family_name].join(' ').squeeze(' ')
    end
  end
end
