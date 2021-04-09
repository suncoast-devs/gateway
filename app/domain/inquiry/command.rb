class Inquiry
  class Command
    include ActiveModel::AttributeAssignment

    delegate :errors, to: :aggregate_root

    attr :aggregate_root

    def initialize(aggregate_id, **payload)
      @aggregate_root = Inquiry.new(aggregate_id)
      @attributes = payload
      assign_attributes @attributes
    end

    def execute
      events = Inquiry::Event.by_aggregate(@aggregate_root.id)
      @aggregate_root.replay(events)
      @aggregate_root.send("#{self.class.name.demodulize.underscore}!", **@attributes)
    end
  end
end
