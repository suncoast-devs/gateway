describe WebhookEvent::Controller do
  include Rack::Test::Methods

  let(:app) { subject }

  it 'handles POST' do
    post '/'
    expect(last_response).to be_ok
  end
end
