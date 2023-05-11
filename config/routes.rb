Rails.application.routes.draw do
  root 'repositories#index'
  get '/repositories', to: 'repositories#index'
  get '/form-page', to: 'pages#form_page'

  resources :repositories
end
