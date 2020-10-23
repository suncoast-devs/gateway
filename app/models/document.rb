class Document < ApplicationRecord
  belongs_to :person
  belongs_to :user
  has_one_attached :file

  validates :label, presence: true
  validates :file, presence: true
end
