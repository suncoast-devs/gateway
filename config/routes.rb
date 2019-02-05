# frozen_string_literal: true

Rails.application.routes.draw do
  scope :legacy do
    resources :program_applications, only: %i[index show edit update], path: "apps"

    resources :program_enrollments, only: %i[index show edit update], path: "enrollments" do
      resources :program_acceptances, except: %i[index destroy] do
        member do
          patch "deliver"
        end
      end
    end

    resources :people do
      resources :notes, only: %i[create update destroy]
    end

    resources :invoices, only: %i[index show new create]
    resources :cohorts, except: %i[show]
    resources :course_registrations, only: %i[index]
  end

  get "sign_in", to: redirect("/auth/#{Rails.env.production? ? :google_oauth2 : :developer}")
  get "sign_out", to: "sessions#destroy"
  get "auth/failure", to: redirect("/")
  match "auth/:provider/callback", to: "sessions#create", via: %i[get post]

  defaults format: :json do
    post "apply", to: "apply#create"
    patch "apply/:id", to: "apply#update"
    get "apply/:id", to: "apply#continue"
    post "lead", to: "hooks#lead"

    ["stripe", "postmark", "activecampaign", "slack"].each do |hook|
      post "/hooks/#{hook}", to: "hooks##{hook}"
    end

    namespace :api do
      post "register", to: "registration#create"
    end
  end

  get "s/:locator", to: "student#status", as: :student_status

  get "*path", to: "home#index"
  root to: "home#index"
end
