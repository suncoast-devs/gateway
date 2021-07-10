# frozen_string_literal: true
class Tag < ApplicationRecord
  has_many :taggings
  has_many :people, through: :taggings, source: :taggable, source_type: Person
  validates :name, presence: true, uniqueness: true
end
