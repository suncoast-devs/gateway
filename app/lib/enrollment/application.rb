module Enrollment
  class Application
    include AggregateRoot

    class AssociatedWithLead < RailsEventStore::Event; end
    class Submitted < RailsEventStore::Event; end

    class HasBeenAlreadySubmitted < StandardError; end

    def initialize(id)
      @id = id
      @state = :new
    end

    def submit(contact, responses)
      raise HasBeenAlreadySubmitted if @state == :submitted
      apply(Submitted.new(data: {
                            id: @id,
                            submitted_at: Time.now,
                            contact: contact,
                            responses: responses,
                          }))
    end

    on Submitted do |event|
      @state = :submitted
      @submitted_at = event.data.fetch(:submitted_at)
      @contact = event.data.fetch(:contact)
      @responses = event.data.fetch(:responses)
    end
  end
end
