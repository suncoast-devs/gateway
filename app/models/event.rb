# frozen_string_literal: true
class Event < ApplicationRecord
  has_many :notifications
  belongs_to :instigator, class_name: 'User', optional: true

  delegate :title, :message, :link_url, :is_notifiable?, to: :formatter

  serialize :payload, PayloadSerializer

  private

  def formatter
    @formatter ||= EventFormatter.new(self)
  end
end
