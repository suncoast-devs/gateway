# NOTE: Can maybe use advisory locks (pg_advisory_xact_lock) to ensure linearized event captures
class Inquiry::Event < ActiveRecord::Base
  scope :by_aggregate, ->(root_id) { where(aggregate: root_id).order(id: "ASC") }
  serialize :payload, JsonHashSerializer

  def readonly?
    !new_record?
  end
end
