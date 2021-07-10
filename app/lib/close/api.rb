# frozen_string_literal: true
require 'net/http'
require 'uri'
require 'json'

module Close
  module API
    def self.get(path, params = nil)
      path = normalize(path)
      path += "?#{URI.encode_www_form(params)}" if params
      request = Net::HTTP::Get.new(path)
      request.basic_auth(Rails.application.credentials.close_api_key, '')
      response = Net::HTTP.start('api.close.com', 443, { use_ssl: true }) { |http| http.request(request) }
      JSON.parse(response.body)
    end

    def self.post(path, params = {})
      path = normalize(path)
      request = Net::HTTP::Post.new(path)
      request.basic_auth(Rails.application.credentials.close_api_key, '')
      request.content_type = 'application/json'
      request.body = JSON.dump(params)
      response = Net::HTTP.start('api.close.com', 443, { use_ssl: true }) { |http| http.request(request) }
      JSON.parse(response.body)
    end

    def self.put(path, params = {})
      path = normalize(path)
      request = Net::HTTP::Put.new(path)
      request.basic_auth(Rails.application.credentials.close_api_key, '')
      request.content_type = 'application/json'
      request.body = JSON.dump(params)
      response = Net::HTTP.start('api.close.com', 443, { use_ssl: true }) { |http| http.request(request) }
      JSON.parse(response.body)
    end

    def self.delete(path)
      path = normalize(path)
      request = Net::HTTP::Delete.new(path)
      request.basic_auth(Rails.application.credentials.close_api_key, '')
      response = Net::HTTP.start('api.close.com', 443, { use_ssl: true }) { |http| http.request(request) }
      JSON.parse(response.body)
    end

    def self.normalize(path)
      path.delete_prefix! '/'
      path += '/' unless path.end_with?('/')
      "/api/v1/#{path}"
    end
  end
end
