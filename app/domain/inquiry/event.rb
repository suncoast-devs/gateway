# NOTE: Can maybe use advisory locks (pg_advisory_xact_lock) to ensure linearized event captures
class Inquiry::Event < ActiveRecord::Base
  include Wisper::Publisher

  scope :by_aggregate, ->(root_id) { where(aggregate: root_id).order(id: "ASC") }
  serialize :payload, JsonHashSerializer

  after_commit :publish, on: :create

  def readonly?
    !new_record?
  end

  def publish
    event_channel = Inquiry.table_name_prefix + self.class.name.demodulize.underscore
    broadcast(event_channel, self)
  end
end
