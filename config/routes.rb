Rails.application.routes.draw do
  root 'repositories#index'
  get '/repositories', to: 'repositories#index'
  get '/form-page', to: 'pages#form_page'
  get '/repositories/:id/edit', to: 'repositories#edit', as: 'edit_repository'
  patch '/repositories/:id', to: 'repositories#update', as: 'update_repository'
  resources :repositories
end
