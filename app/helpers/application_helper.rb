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

  def format_answer(answer)
    case answer
    when true then 'Yes'
    when false then 'No'
    else
      simple_format answer.to_s
    end
  end

  def current_controller?(test_name)
    'is-active' if controller.controller_name == test_name
  end
end
