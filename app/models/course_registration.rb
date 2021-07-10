# frozen_string_literal: true
class CourseRegistration < ApplicationRecord
  belongs_to :person
  belongs_to :course
  belongs_to :invoice, optional: true

  before_create :determine_fee

  private

  def determine_fee
    self.fee = code =~ /guildies/i ? 800 : 1200
  end
end
