# frozen_string_literal: true
class Communication < ApplicationRecord
  belongs_to :person
  belongs_to :user, optional: true

  scope :recent, -> { order(messaged_at: :desc) }
  scope :unread, -> { where(is_unread: true) }

  enum media: {email: 0, sms: 1}

  enum direction: {outgoing: 0, incoming: 1}
end
