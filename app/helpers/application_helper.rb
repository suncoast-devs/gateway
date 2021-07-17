# frozen_string_literal: true

require 'pagy/extras/bulma'

# :nodoc:
module ApplicationHelper
  include Pagy::Frontend

  def title(page_title)
    content_for(:title) { page_title }
    page_title
  end

  def gravatar_for(user)
    gravatar_id = Digest::MD5.hexdigest(user&.email&.downcase || '?')
    gravatar_url = "http://gravatar.com/avatar/#{gravatar_id}"
    image_tag(gravatar_url, alt: user&.name, class: 'gravatar')
  end

  def format_answer(answer)
    case answer
    when true
      'Yes'
    when false
      'No'
    else
      simple_format answer.to_s
    end
  end

  def current_controller?(test_name)
    'is-active' if controller.controller_name == test_name
  end

  def usd(amount)
    number_to_currency amount, unit: '$'
  end

  def intent_for_stage(stage)
    case stage
    when 'cancelled'
      'is-warning lighten'
    when 'prospecting'
      'is-warning'
    when 'applied'
      'is-info lighten'
    when 'interviewing'
      'is-info'
    when 'accepted'
      'is-primary'
    when 'enrolling'
      'is-success lighten'
    when 'enrolled', 'graduated'
      'is-success'
    when 'rejected', 'dropped'
      'is-danger'
    when 'incomplete'
      'is-danger lighten'
    end
  end

  def intent_for_status(status)
    case status
    when 'potential'
      'is-info lighten'
    when 'interested', 'qualified'
      'is-info'
    when 'customer'
      'is-success'
    when 'bad_fit'
      'is-danger'
    when 'uninterested', 'irrelevant'
      'is-warning'
    end
  end

  def markdown(markdown)
    CommonMarker.render_html(markdown, :DEFAULT).html_safe
  end

  def sign_in_path
    "/auth/#{Rails.env.production? ? :google_oauth2 : :developer}"
  end
end
