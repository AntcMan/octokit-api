Rails.application.routes.draw do
  root 'repositories#index'
  get '/repositories', to: 'repositories#index'
  get '/form-page', to: 'pages#form_page'
  patch '/repositories/:id/edit', to: 'repositories#edit', as: 'edit_repository'
  resources :repositories
end
