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
    include Import['webhook_event.repository']

    before { post '/hooks/noop', payload, { 'CONTENT_TYPE' => 'application/json' } }

    let(:relation) { repository.container.relations[:webhook_events] }

    it 'is successful' do
      expect(last_response).to be_ok
      expect(relation.count).to eq(1)
    end

    it 'persists parameters' do
      event = relation.first
      expect(event[:name]).to eq('noop')
      expect(event[:payload]).to eq(payload)
    end
  end
end
