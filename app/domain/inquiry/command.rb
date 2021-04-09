class Inquiry
  class Command
    include ActiveModel::AttributeAssignment

    delegate :errors, to: :aggregate

    attr :aggregate

    def initialize(aggregate_id, **payload)
      @aggregate = Inquiry.new(aggregate_id)
      @attributes = payload
      assign_attributes @attributes
    end

    def execute
      events = Inquiry::Event.by_aggregate(@aggregate.id)
      @aggregate.replay(events)
      @aggregate.send("#{self.class.name.demodulize.underscore}!", **@attributes)
    end
  end
end
