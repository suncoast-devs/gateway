class CourseRegistration < ApplicationRecord
  belongs_to :person
  belongs_to :course
  belongs_to :invoice, optional: true
end
