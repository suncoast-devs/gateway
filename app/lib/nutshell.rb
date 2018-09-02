# frozen_string_literal: true

require 'nutshell-crm-api'

# Nutshell API wrapper
module Nutshell
  def self.client
    NutshellCrmAPI::Client.new(
      Rails.application.credentials.nutshell[:email],
      Rails.application.credentials.nutshell[:token]
    )
  end
end
