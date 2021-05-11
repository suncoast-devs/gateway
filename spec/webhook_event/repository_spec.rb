# frozen_string_literal: true
require 'webhook_event/repository'

describe WebhookEvent::Repository do
  context 'creating a webhook event' do
    let(:new_event) { subject.create({ name: 'example', payload: '{ "a": 1 }', received_at: Time.now }) }

    it 'to have an ID' do
      expect(new_event.id).not_to be_nil
    end
  end
end
