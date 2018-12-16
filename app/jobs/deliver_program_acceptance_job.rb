class DeliverProgramAcceptanceJob < ApplicationJob
  queue_as :default

  def perform(*args)
    DeliverProgramAcceptance.call(*args)
  end
end
