# frozen_string_literal: true

# Async worker for syncing data in CRMs
class SyncDealJob < ApplicationJob
  queue_as :default

  def perform(enrollment_id)
    ConnectProgramEnrollmentToActiveCampaign.call(enrollment_id) if Rails.env.production?
  end
end
