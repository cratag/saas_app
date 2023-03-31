Rails.application.routes.draw do
  resources :tenants do
    resources :projects
  end

  devise_for :users, controllers: { registrations: 'registrations' }

  root 'home#index'
end
