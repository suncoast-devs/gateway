# frozen_string_literal: true

Rails.application.routes.draw do
  resources :program_applications, only: %i[index show edit update], path: "apps" do
    resources :notes, only: %i[create update destroy]
  end

  resources :program_enrollments, only: %i[index show edit update], path: "enrollments"

  resources :people do
    resources :program_acceptances, except: %i[index destroy] do
      member do
        patch "deliver"
      end
    end
  end

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
    post "/hooks/stripe", to: "hooks#stripe"
    post "/hooks/postmark", to: "hooks#postmark"
    post "/hooks/activecampaign", to: "hooks#activecampaign"
  end

  root to: "home#index"
end
