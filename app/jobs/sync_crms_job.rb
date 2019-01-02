# frozen_string_literal: true

# Async worker for syncing data in CRMs
class SyncCrmsJob < ApplicationJob
  queue_as :default

  def perform(person_id)
    ConnectPersonToActiveCampaign.call(person_id)
  end
end
