# frozen_string_literal: true
require 'webhook_event/controller'

describe WebhookEvent::Controller do
  include Rack::Test::Methods

  let(:app) { subject }
  let(:payload) { JSON.dump({ '_id': '6095fa3ad01e975435a3d73c', 'isActive': false }) }

  it 'handles POST requests' do
    post '/hooks/noop'
    expect(last_response).to be_ok
  end

  it 'does not handle GET requests' do
    get '/hooks/noop'
    expect(last_response).to_not be_ok
  end

  context 'creating an event' do
    before { post '/hooks/noop', payload, { 'CONTENT_TYPE' => 'application/json' } }

    it 'is successful' do
      expect(last_response).to be_ok
    end
  end
end
