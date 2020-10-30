class Communication < ApplicationRecord
  belongs_to :person
  belongs_to :user, optional: true

  enum media: %i[email sms]

  enum direction: %i[outgoing incoming]

  after_create :update_persons_last_communication

  def update_persons_last_communication
    person.update last_communication: self
  end
end
