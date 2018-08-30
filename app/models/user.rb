class User < ApplicationRecord
  has_many :notes

  def self.from_auth_hash(auth)
    return unless auth.info.email.match(/@suncoast.io$/)
    where(uid: auth.uid).first_or_initialize.tap do |user|
      user.uid = auth.uid
      user.name = auth.info.name
      user.email = auth.info.email
      user.save!
    end
  end
end
