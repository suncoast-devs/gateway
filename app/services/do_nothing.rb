# frozen_string_literal: true

# Provides a service for doing nothing.
class DoNothing
  include Callable

  def initialize(thing)
    @thing = thing
  end

  def call
    Rails.logger.debug "Nothing has been done with #{@thing}"
  end
end
