Rails.application.routes.draw do
  mount RailsEventStore::Browser => "/res" if Rails.env.development?

  namespace :api do
    post "applications/submit", to: "applications#submit"
  end
end
