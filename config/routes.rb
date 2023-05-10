Rails.application.routes.draw do
  root 'repositories#index'
  get '/repositories', to: 'repositories#index'
end
