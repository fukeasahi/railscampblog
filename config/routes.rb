Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'articles#index'
  resources :articles, only: [:new, :create, :show, :edit, :update, :destroy]
  resource :redis, only: %i[show]
end
