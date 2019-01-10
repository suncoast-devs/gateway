# frozen_string_literal: true

Rails.application.routes.draw do
  resources :program_applications, only: %i[index show edit update], path: "apps" do
    resources :notes, only: %i[create update destroy]
  end

  resources :program_enrollments, only: %i[index show edit update], path: "enrollments" do
    resources :program_acceptances, except: %i[index destroy] do
      member do
        patch "deliver"
      end
    end
  end

  resources :people
  resources :invoices, only: %i[index show new create]
  resources :cohorts, except: %i[show]

  get "sign_in", to: redirect("/auth/#{Rails.env.production? ? :google_oauth2 : :developer}")
  get "sign_out", to: "sessions#destroy"
  get "auth/failure", to: redirect("/")
  match "auth/:provider/callback", to: "sessions#create", via: %i[get post]

  defaults format: :json do
    post "apply", to: "apply#create"
    patch "apply/:id", to: "apply#update"
    post "lead", to: "hooks#lead"

    ["stripe", "postmark", "activecampaign", "slack"].each do |hook|
      post "/hooks/#{hook}", to: "hooks##{hook}"
    end
  end

  get "s/:locator", to: "student#status", as: :student_status

  root to: "home#index"
end
