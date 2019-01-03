class Tag < ApplicationRecord
  has_many :taggings
  has_many :people, through: :taggings, source: :taggable, source_type: Person
end
