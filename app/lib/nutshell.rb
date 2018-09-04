# frozen_string_literal: true

require 'nutshell-crm-api'

CREDENTIALS = Rails.application.credentials[Rails.env.to_sym][:nutshell]

# Nutshell API wrapper
module Nutshell
  def self.client
    NutshellCrmAPI::Client.new(CREDENTIALS[:email], CREDENTIALS[:token])
  end
end
