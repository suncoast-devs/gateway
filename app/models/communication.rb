class Communication < ApplicationRecord
  belongs_to :person
  belongs_to :user, optional: true

  scope :recent, -> { order(messaged_at: :desc) }

  enum media: %i[email sms]

  enum direction: %i[outgoing incoming]

  after_create :update_persons_last_communication
  after_save :broadcast_new_unread_count

  def update_persons_last_communication
    person.update last_communication: self
  end

  def broadcast_new_unread_count
    if incoming?
      CommunicationChannel.broadcast_unread
    end
  end
end
