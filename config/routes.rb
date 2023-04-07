Rails.application.routes.draw do
  resources :artifacts
  resources :tenants do
    resources :projects
  end

  devise_for :users, controllers: { registrations: 'registrations' }

  root 'home#index'

  match '/plan/edit' => 'tenants#edit', via: :get, as: :edit_plan
  match '/plan/update' => 'tenants#update', via: [:put, :patch], as: :update_plan
end
