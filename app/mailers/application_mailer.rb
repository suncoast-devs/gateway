class ApplicationMailer < ActionMailer::Base
  default from: "Suncoast Developers Guild <hello@suncoast.io>"
  layout "simple_email"
end
