# frozen_string_literal: true

Rails.application.routes.draw do
  resources :program_applications, only: %i[index show edit update], path: "apps" do
    resources :notes, only: %i[create update destroy]
  end

  resources :people
  resources :invoices
  resources :cohorts, except: [:show]

  get "sign_in", to: redirect("/auth/#{Rails.env.production? ? :google_oauth2 : :developer}")
  get "sign_out", to: "sessions#destroy"
  get "auth/failure", to: redirect("/")
  match "auth/:provider/callback", to: "sessions#create", via: %i[get post]

  defaults format: :json do
    post "apply", to: "apply#create"
    patch "apply/:id", to: "apply#update"
    post "lead", to: "hooks#lead"
    post "/hooks/stripe", to: "hooks#stripe"
  end

  root to: "home#index"
end
