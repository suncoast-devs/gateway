Rails.application.routes.draw do
  get "cohorts/new", to: "cohorts#new"
  post "cohorts", to: "cohorts#create"
end
