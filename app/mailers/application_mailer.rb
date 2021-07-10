# frozen_string_literal: true
class ApplicationMailer < ActionMailer::Base
  default from: 'Suncoast Developers Guild <hello@suncoast.io>'
  layout 'simple_email'
end
