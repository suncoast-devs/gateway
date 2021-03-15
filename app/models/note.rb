# frozen_string_literal: true

# Polymorphic Note model
class Note < ApplicationRecord
  include Discard::Model
  belongs_to :notable, polymorphic: true
  belongs_to :user, optional: true
end
