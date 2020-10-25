# frozen_string_literal: true
require 'sidekiq/web'

Rails.application.routes.draw do
  resources :program_applications, only: %i[index show edit update], path: "apps"
  resources :program_enrollments, only: %i[index show edit update], path: "enrollments" do
    resources :program_acceptances, except: %i[index destroy] do
      member do
        patch "deliver"
      end
    end
  end

  resources :people do
    resources :contact_dispositions, only: %i[create destroy]
    resources :documents, except: %i[index]
    resources :notes, only: %i[create update destroy]
  end

  resources :invoices, only: %i[index show new create]
  resources :cohorts
  resources :communication_templates
  resources :course_registrations, only: %i[index]

  # Authentication
  get "sign_in", to: redirect("/auth/#{Rails.env.production? ? :google_oauth2 : :developer}")
  get "sign_out", to: "sessions#destroy"
  get "auth/failure", to: redirect("/")
  match "auth/:provider/callback", to: "sessions#create", via: %i[get post]

  mount Sidekiq::Web => '/sidekiq', constraints: lambda { |request| User.exists?(request.session[:user_id]) }

  defaults format: :json do
    post "apply", to: "apply#create"
    patch "apply/:id", to: "apply#update"
    get "apply/:id", to: "apply#continue"
    post "lead", to: "hooks#lead"

    ["stripe", "postmark", "slack"].each do |hook|
      post "/hooks/#{hook}", to: "hooks##{hook}"
    end

    namespace :api do
      post "register", to: "registration#create"
      get "cohorts", to: "public#cohorts"

      post "webhooks/:webhook", to: "webhooks#index"
    end
  end

  get "s/:locator", to: "student#status", as: :student_status

  root to: "home#index"
end
