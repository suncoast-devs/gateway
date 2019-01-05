# frozen_string_literal: true

BASE_URL = Rails.application.credentials.active_campaign_url
API_KEY = Rails.application.credentials.active_campaign_key

module ActiveCampaign
  def self.get(action, params = nil)
    HTTP.headers("Api-Token" => API_KEY).get("#{BASE_URL}/#{action}", params: params).parse
  end

  def self.post(action, params = nil)
    HTTP.headers("Api-Token" => API_KEY).post("#{BASE_URL}/#{action}", json: params).parse
  end

  def self.put(action, params = nil)
    HTTP.headers("Api-Token" => API_KEY).put("#{BASE_URL}/#{action}", json: params).parse
  end
end
