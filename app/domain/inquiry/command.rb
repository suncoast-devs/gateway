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
  end
end
