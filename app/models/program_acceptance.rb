# frozen_string_literal: true
class ProgramAcceptance < ApplicationRecord
  include Discard::Model
  belongs_to :cohort
  belongs_to :program_enrollment

  delegate :person, to: :program_enrollment

  scope :active, -> { where(is_rescinded: false) }

  PAYMENT_URLS = {
    "NS Full" => "https://app.paythen.co/company/sdg/plan/epb5fwaoqv",
    "NS 1 Scholarship" => "https://app.paythen.co/company/sdg/plan/ymbmv0jvvc",
    "NS 2 Scholarships" => "https://app.paythen.co/company/sdg/plan/8pcdc265kx",
    "NS Full (D)" => "https://app.paythen.co/company/sdg/plan/an43jwie06",
    "NS 1 Scholarship (D)" => "https://app.paythen.co/company/sdg/plan/i3v3oylshq",
    "NS 2 Scholarships (D)" => "https://app.paythen.co/company/sdg/plan/d90y4weicq"
  }.freeze

  def to_liquid
    ProgramAcceptanceDrop.new(self)
  end
end
