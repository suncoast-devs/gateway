class Communication < ApplicationRecord
  belongs_to :person
  belongs_to :user, optional: true

  scope :recent, -> { order(messaged_at: :desc) }
  scope :unread, -> { where(is_unread: true) }

  enum media: %i[email sms]

  enum direction: %i[outgoing incoming]
end
