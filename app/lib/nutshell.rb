require 'nutshell-crm-api'

module Nutshell

  def self.client
    NutshellCrmAPI::Client.new(
      Rails.application.credentials.nutshell[:email],
      Rails.application.credentials.nutshell[:token]
    )
  end
end
