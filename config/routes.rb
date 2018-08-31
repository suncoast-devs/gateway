Rails.application.routes.draw do
  resources :program_applications, only: [:index, :show, :update] do
    resources :notes, only: [:create, :update, :destroy]
  end

  get 'sign_in', to: redirect("/auth/#{Rails.env.production? ? :google_oauth2 : :developer}")
  get 'sign_out', to: 'sessions#destroy'
  get 'auth/failure', to: redirect('/')
  match 'auth/:provider/callback', to: 'sessions#create', via: %i[get post]

  root to: 'home#index'
end
