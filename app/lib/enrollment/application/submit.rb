module Enrollment
  class Application
    class Submit < Command
      attribute :id, Types::UUID
      attribute :contact, Types::Hash
      attribute :responses, Types::Hash

      alias :aggregate_id :id

      class Handler
        include CommandHandler

        def call(command)
          with_aggregate(Enrollment::Application, command.aggregate_id) do |application|
            application.submit(command.contact, command.responses)
          end
        end
      end
    end
  end
end
