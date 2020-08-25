Dir.glob("#{Rails.root}/app/models/*.rb").each { |p| require_dependency p } # if Rails.env.development?

module TypeGenerator
  MODELS = ApplicationRecord.descendants

  def define_types
    MODELS.each do |model|
      type_name = "#{model.name}Type"

      Types.const_set(
        type_name,
        Class.new(Types::BaseObject) do
          foreign_keys = model.reflect_on_all_associations(:belongs_to).map(&:foreign_key)
          model.columns.each do |column|
            next if foreign_keys.include? column.name
            if model.defined_enums.include? column.name
              enum = Types.const_set(
                "#{model.name}#{column.name.classify}Enum",
                Class.new(Types::BaseEnum) do
                  model.defined_enums[column.name].keys.each do |key|
                    value key
                  end
                end
              )
              field column.name, enum, null: column.null
            else
              field column.name, TypeGenerator.type_for(model, column), null: column.null
            end
          end
        end
      )
    end
  end

  def define_associations
    all do |type, model|
      type.class_eval do
        model.reflect_on_all_associations(:belongs_to).each do |reflection|
          nullable = !reflection.options[:required] || !!reflection.options[:optional]

          if reflection.options[:polymorphic]
            types = MODELS.
              select { |m| m.reflect_on_all_associations.any? { |r| r.options[:as] == reflection.name } }.
              map { |m| [m, Types.const_get("#{m.name}Type")] }.
              to_h

            union = Types.const_set(
              "#{reflection.name.to_s.classify}Union",
              Class.new(Types::BaseUnion) do
                possible_types *types.values

                define_singleton_method :resolve_type do |object, context|
                  types[object]
                end
              end
            )
            field reflection.name, union, null: true
          else
            field reflection.name, Types.const_get("#{reflection.klass}Type"), null: nullable
          end
        end

        model.reflect_on_all_associations(:has_many).each do |reflection|
          field reflection.plural_name, [Types.const_get("#{reflection.klass}Type")], null: false
        end

        model.reflect_on_all_associations(:has_one).each do |reflection|
          field reflection.name, Types.const_get("#{reflection.klass}Type"), null: !reflection.options[:required]
        end
      end
    end
  end

  def define_inputs
    all do |type, model|
      input_name = "#{model.name}Attributes"

      Types.const_set(
        input_name,
        Class.new(Types::BaseInputObject) do
          ignored_columns = [model.primary_key, "created_at", "updated_at"]
          model.columns.each do |column|
            next if ignored_columns.include? column.name
            argument column.name, TypeGenerator.type_for(model, column), required: false
          end
        end
      )
    end
  end

  def define_mutations
    all do |type, model|
      field_name = model.name.underscore

      Mutations.const_set(
        "Create#{model.name}",
        Class.new(Mutations::BaseMutation) do
          argument :attributes, Types.const_get("#{model.name}Attributes"), required: true
          field field_name, type, null: true
          field :errors, [String], null: false

          define_method :resolve do |arguments|
            resource = model.new arguments[:attributes].to_h

            if resource.save
              {
                "#{field_name}": resource,
                errors: [],
              }
            else
              {
                "#{field_name}": nil,
                errors: resource.errors.full_messages,
              }
            end
          end
        end
      )

      Mutations.const_set(
        "Update#{model.name}",
        Class.new(Mutations::BaseMutation) do
          argument :id, GraphQL::Types::ID, required: true
          argument :attributes, Types.const_get("#{model.name}Attributes"), required: true
          field field_name, type, null: true
          field :errors, [String], null: false

          define_method :resolve do |arguments|
            resource = model.find(arguments[:id])

            if resource.update(arguments[:attributes].to_h)
              {
                "#{field_name}": resource,
                errors: [],
              }
            else
              {
                "#{field_name}": nil,
                errors: resource.errors.full_messages,
              }
            end
          end
        end
      )

      Mutations.const_set(
        "Delete#{model.name}",
        Class.new(Mutations::BaseMutation) do
          argument :id, GraphQL::Types::ID, required: true
          field field_name, type, null: true

          define_method :resolve do |arguments|
            resource = model.find(arguments[:id])
            {"#{field_name}": resource.destroy}
          end
        end
      )
    end
  end

  def all
    MODELS.each do |model|
      yield Types.const_get("#{model.name}Type"), model
    end
  end

  private

  # TODO: Handle enum columns
  def self.type_for(model, column)
    return GraphQL::Types::ID if model.primary_key == column.name
    case column.type
    when :boolean then GraphQL::Types::Boolean
    when :date then Types::DateType
    when :datetime then GraphQL::Types::ISO8601DateTime
    when :decimal then GraphQL::Types::Float
    when :integer then GraphQL::Types::Int
    when :json, :jsonb then Types::JSONType
    when :string, :text then GraphQL::Types::String
    when :uuid then Types::UUIDType
    else
      raise "UNKNOWN TYPE: #{column.type}"
    end
  end

  def self.extended(base)
    base.define_types
    base.define_associations
    base.define_inputs
    base.define_mutations
  end

  extend self
end
