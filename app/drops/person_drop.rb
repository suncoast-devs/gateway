# frozen_string_literal: true
class PersonDrop < Liquid::Drop
  
  delegate :full_name, :email_address, :phone_number,
    :given_name, :middle_name, :family_name,
    to: :@person, allow_nil: true

  def initialize(person)
    @person = person
  end
end
