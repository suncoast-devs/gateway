# frozen_string_literal: true

Rails.application.routes.draw do
  resources :program_applications, only: %i[index show update], path: 'apps' do
    resources :notes, only: %i[create update destroy]
  end

  get 'sign_in', to: redirect("/auth/#{Rails.env.production? ? :google_oauth2 : :developer}")
  get 'sign_out', to: 'sessions#destroy'
  get 'auth/failure', to: redirect('/')
  match 'auth/:provider/callback', to: 'sessions#create', via: %i[get post]

  root to: 'home#index'
end
