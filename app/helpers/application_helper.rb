# frozen_string_literal: true
require 'pagy/extras/bulma'

# :nodoc:
module ApplicationHelper
  include Pagy::Frontend

  def gravatar_for(user)
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    gravatar_url = "http://gravatar.com/avatar/#{gravatar_id}"
    image_tag(gravatar_url, alt: user.name, class: 'gravatar')
  end
end
