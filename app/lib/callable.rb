# frozen_string_literal: true

# Do not instantiate service objects directly
module Callable
  extend ActiveSupport::Concern

  class_methods do
    def call(*args)
      new(*args).call
    end
  end
end
