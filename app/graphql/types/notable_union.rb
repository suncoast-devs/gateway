class Types::NotableUnion < Types::BaseUnion
  possible_types Types::PersonType

  def self.resolve_type(object, context)
    case object
    when Person then Types::PersonType
    end
  end
end
