module Types
  class QueryType < Types::BaseObject
    TypeGenerator.all do |type, model|
      field_name = model.name.underscore

      field field_name, type, null: true do
        description "Find a #{model.name.humanize} by ID"
        argument :id, GraphQL::Types::ID, required: true
      end

      define_method field_name do |params|
        model.where(id: params[:id]).first
      end

      field field_name.pluralize, [type], null: true do
        description "All #{model.name.humanize.pluralize}"
      end

      # TODO: Pagination, filtering, etc.
      define_method field_name.pluralize do
        model.all
      end
    end
  end
end
