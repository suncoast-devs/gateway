# frozen_string_literal: true

# User model, login is restricted to suncoast.io email addresses
class User < ApplicationRecord
  has_many :notes
  has_many :notifications
  has_many :events, through: :notifications

  scope :notifiable, -> { where(is_notifiable: true) }

  def self.from_auth_hash(auth)
    return unless auth.info.email =~ /@suncoast.io$/
    where(uid: auth.uid)
      .first_or_initialize
      .tap do |user|
        user.uid = auth.uid
        user.name = auth.info.name
        user.email = auth.info.email
        user.save!
      end
  end

  def first_name
    name.split.first
  end
end
