class Inquiry
  include ActiveModel::Validations

  class_attribute :event_handlers, default: ActiveSupport::HashWithIndifferentAccess.new

  attr_accessor :id, :form, :contact, :responses, :is_complete

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
    self.contact = payload.dig(:contact)
    self.responses = payload.dig(:responses)
    self.is_complete = payload.dig(:is_complete)
  end

  on :updated do |payload|
    self.responses = payload.dig(:responses)
  end

  on :completed do |payload|
    self.is_complete = true
  end

  def create!(form: nil, contact: {}, responses: [], is_complete: false)
    success = false
    Inquiry::Event.transaction do
      emit(:created, form: form, contact: contact, responses: [], is_complete: false)
      raise ActiveRecord::Rollback unless valid?(:create)
      success = true
    end
    success
  end

  def update!(responses: [])
    success = false
    Inquiry::Event.transaction do
      emit(:updated, responses: responses)
      raise ActiveRecord::Rollback unless valid?(:update)
      success = true
    end
    success
  end

  def complete!
    success = false
    Inquiry::Event.transaction do
      emit(:completed)
      raise ActiveRecord::Rollback unless valid?(:complete)
      success = true
    end
    success
  end

  def emit(event_name, **payload)
    event_class = Inquiry::Event.const_get(event_name.to_s.camelize)
    event = event_class.new(aggregate: id, payload: payload)
    apply(event)
    event.save!
  end
end
