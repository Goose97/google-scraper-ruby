Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root 'keywords#index'

  resources :keywords, only: %i[index create show]

  namespace :api do
    namespace :v1 do
      resources :keywords, only: %i[index]
    end
  end
end
