module Types
  # TODO: Remove this with next release of `graphql-ruby` (> 1.9.4)
  class JSONType < Types::BaseScalar
    description "Represents untyped JSON"

    def self.coerce_input(value, _context)
      value
    end

    def self.coerce_result(value, _context)
      value
    end
  end
end
