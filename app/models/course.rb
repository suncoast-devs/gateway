class Course < ApplicationRecord
  has_many :course_registrations
  has_many :people, through: :course_registrations
end
