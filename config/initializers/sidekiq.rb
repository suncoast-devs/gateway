# frozen_string_literal: true
Sidekiq.configure_client { |config| config.redis = { size: 1 } }

Sidekiq.configure_server do
  Sidekiq::Cron::Job.create(name: 'Invoice Installments', cron: '0 8 * * *', class: 'InvoiceInstallmentsJob')
end
