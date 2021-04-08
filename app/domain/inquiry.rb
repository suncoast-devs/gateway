class Inquiry
  include ActiveModel::Validations
  include ActiveModel::Attributes

  class_attribute :event_handlers, default: ActiveSupport::HashWithIndifferentAccess.new

  attr_accessor :form, :responses

  validates :form, presence: true, on: :create

  class << self
    def table_name_prefix
      "inquiry_"
    end

    def on(event_name, &block)
      event_handlers[event_name] = block
    end
  end

  def initialize(id)
    @id = id
  end

  def replay(events)
    events.each { |event| apply(event) }
  end

  def apply(event)
    instance_exec(event.payload, &event_handlers[event.class.name.demodulize.underscore])
  end

  on :created do |payload|
    self.form = payload.dig(:form)
  end

  on :updated do |payload|
    self.responses = payload.dig(:responses)
  end

  def create!(form: nil, contact: {})
    Inquiry::Event.transaction do
      emit(:created, form: form, contact: contact)
      raise ActiveRecord::Rollback unless valid?(:create)
    end
  end

  def update!(responses: [])
    Inquiry::Event.transaction do
      emit(:updated, responses: responses)
      raise ActiveRecord::Rollback unless valid?(:update)
    end
  end

  def emit(event_name, **payload)
    event_class = Inquiry::Event.const_get(event_name.to_s.camelize)
    event = event_class.new(aggregate: @id, payload: payload)
    apply(event)
    event.save! if valid?
  end
end
