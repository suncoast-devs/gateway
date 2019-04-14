module Types
  class MutationType < Types::BaseObject
    TypeGenerator.all do |type, model|
      field "create_#{model.name.underscore}", mutation: Mutations.const_get("Create#{model.name}")
      field "update_#{model.name.underscore}", mutation: Mutations.const_get("Update#{model.name}")
      field "delete_#{model.name.underscore}", mutation: Mutations.const_get("Delete#{model.name}")
    end
  end
end
