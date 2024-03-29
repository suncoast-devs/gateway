# frozen_string_literal: true
module ShortURL
  API_KEY = Rails.application.credentials.sdg_codes_api_key
  API_URL = { 'development' => 'http://0.0.0.0:3001', 'production' => 'https://sdg.codes' }.freeze

  def self.generate(label, url, slug = nil)
    data = { label:, url:, slug: }
    HTTP.headers('Authorization' => "Bearer #{API_KEY}").post("#{API_URL[Rails.env]}/api/links", json: data).parse[
      'url'
    ]
  end
end
