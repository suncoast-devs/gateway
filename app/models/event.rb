class Event < ApplicationRecord
  has_many :notifications
  belongs_to :instigator, class_name: "User", optional: true

  delegate :title, :message, :link_url, to: :formatter

  private

  def formatter
    @formatter ||= EventFormatter.new(self)
  end
end
