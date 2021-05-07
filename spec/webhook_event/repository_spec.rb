require 'webhook_event/repository'

describe WebhookEvent::Repository do
  it 'creates a webhook event' do
    event = subject.create({ name: 'example', payload: { a: 1 }, received_at: Time.now })
    expect(event.name).to eq('example')
    expect(event.payload['a']).to eq(1)
    expect(subject.container.relations[:webhook_events].count).to eq(1)
  end
end
