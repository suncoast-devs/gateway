class ContactDisposition < ApplicationRecord
  belongs_to :person
  belongs_to :user
  enum code: %i[attempted succeeded]

  scope :by_recent, -> { order(contacted_at: :desc) }  
  
  after_create :update_persons_last_contact_disposition

  def update_persons_last_contact_disposition
    person.update last_contact_disposition: self
  end
end
