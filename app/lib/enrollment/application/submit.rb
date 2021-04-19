module Enrollment
  class Application
    class Submit < Command
      attribute :id, Types::UUID

      attribute :contact do
        attribute :full_name, Types::String
        attribute :email_address, Types::String.optional
        attribute :phone_number, Types::String.optional
      end

      attribute :responses, Types::Array do
        attribute :question, Types::String
        attribute :answer, Types::String
      end

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
