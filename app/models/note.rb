# frozen_string_literal: true

# Polymorphic Note model
class Note < ApplicationRecord
  belongs_to :notable, polymorphic: true
  belongs_to :user, optional: true
end
