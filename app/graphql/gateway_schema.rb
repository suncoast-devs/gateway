require "type_generator"

class GatewaySchema < GraphQL::Schema
  mutation Types::MutationType
  query Types::QueryType
end
