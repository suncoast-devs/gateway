# frozen_string_literal: true

# Do not instantiate service objects directly
module Callable
  extend ActiveSupport::Concern

  class_methods do
    def call(*args)
      new(*args).call
    end

    def call_later(*args)
      AsyncServiceJob.perform_later(self.name, *args)
    end

    def call_in(period, *args)
      AsyncServiceJob.set(wait: period).perform_later(self.name, *args)
    end
  end
end
