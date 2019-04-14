require "type_generator" # Load this before Unions

module Types
  class BaseUnion < GraphQL::Schema::Union
  end
end
