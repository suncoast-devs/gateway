module Webhooks
  class Noop
    include Callable

    def initialize(params)
      @params = params.with_indifferent_access
    end

    def call
      # Do stuff.
    end
  end
end
