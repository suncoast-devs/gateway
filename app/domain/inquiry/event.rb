class Inquiry::Event < ActiveRecord::Base
  scope :by_aggregate, ->(root_id) { where(aggregate: root_id).order(id: "ASC") }
  serialize :payload, JsonHashSerializer
end
