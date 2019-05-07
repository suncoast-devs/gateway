class Course < ApplicationRecord
  has_many :course_registrations
  has_many :people, through: :course_registrations

  validates :identifier, presence: true
  validates :name, presence: true
  validates :session, presence: true
  validates :starts_on, presence: true
  validates :ends_on, presence: true
  validates :days, presence: true
  validates :time, presence: true
end
