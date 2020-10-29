class Communication < ApplicationRecord
  belongs_to :person
  belongs_to :user, optional: true

  enum media: %i[email sms]
end
