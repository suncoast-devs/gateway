# frozen_string_literal: true
if Rails.env.production?
  Rails.application.config.action_mailer.delivery_method = :postmark
  Rails.application.config.action_mailer.postmark_settings = {
    api_token: Rails.application.credentials.postmark_api_key,
  }
elsif Rails.env.development?
  Rails.application.config.action_mailer.perform_deliveries = true
  Rails.application.config.action_mailer.delivery_method = :smtp
  Rails.application.config.action_mailer.smtp_settings = {
    user_name: Rails.application.credentials.dig(:mailtrap, :username),
    password: Rails.application.credentials.dig(:mailtrap, :password),
    address: 'smtp.mailtrap.io',
    domain: 'smtp.mailtrap.io',
    port: '2525',
    authentication: :cram_md5,
  }
end

Rails
  .application
  .reloader
  .to_prepare do
    Rails::MailersController.before_action -> { redirect_to :root unless Person.exists? session[:user_id] }
  end
