# frozen_string_literal: true

# The ProgramApplication model represents a potential student's
# application to the Academy.
class ProgramApplication < ApplicationRecord
  include Discard::Model
  belongs_to :person
  belongs_to :program_enrollment, optional: true
  has_many :notes, as: :notable

  scope :visible, -> { where(is_hidden: false) }
  scope :hidden, -> { where(is_hidden: true) }

  enum application_status: {incomplete: 0, complete: 1}, _prefix: 'application'

  def ac_continue_application_url_value
    continue_url || begin
      url = "https://suncoast.io/academy/apply?continue=#{id}"
      short_url = ShortURL.generate("Continue Application for #{person.full_name}", url)
      update(continue_url: short_url)
      short_url
    end
  end
end
