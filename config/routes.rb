# frozen_string_literal: true
require 'sidekiq/web'
require 'sidekiq/cron/web'

# rubocop:disable Metrics/BlockLength
Rails
  .application
  .routes
  .draw do
    resources :program_applications, only: %i[index show edit update], path: 'apps'
    resources :program_enrollments, only: %i[index show edit update], path: 'enrollments' do
      resources :program_acceptances, except: %i[index edit destroy] do
        member { patch 'deliver' }
      end
    end

    resources :people do
      resources :contact_dispositions, only: %i[create destroy]
      resources :documents, except: %i[index] do
        collection { post 'drop' }
      end
      resources :ledger_entries, only: %i[index create], path: 'ledger'
      resources :notes, only: %i[create update destroy]
    end

    resources :invoices, only: %i[index show new create]
    resources :cohorts
    resources :communication_templates
    resources :courses
    resources :webhook_events, only: %i[index show] do
      member { post 'replay' }
    end

    # Authentication
    get 'sign_out', to: 'sessions#destroy'
    get 'auth/failure', to: redirect('/')
    match 'auth/:provider/callback', to: 'sessions#create', via: %i[get post]

    mount Sidekiq::Web => '/sidekiq', :constraints => lambda { |request| User.exists?(request.session[:user_id]) }

    defaults format: :json do
      post 'apply', to: 'apply#create'
      patch 'apply/:id', to: 'apply#update'
      get 'apply/:id', to: 'apply#continue'
      post 'lead', to: 'hooks#lead'

      namespace :api do
        post 'register', to: 'registration#create'
        get 'cohorts', to: 'public#cohorts'

        post 'webhooks/:name', to: 'webhooks#index', as: 'webhooks'
      end

      resources :communications, only: %i[index show new create]
    end

    get 's/:locator', to: 'student#status', as: :student_status

    root to: 'home#index'
  end
# rubocop:enable Metrics/BlockLength