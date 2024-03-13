Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :delivery_partners
  devise_for :customers

  resources :shipments, only: [:index, :new, :create] do
    put 'update_status', on: :member
  end

  put 'delivery_partner/update_availability', to: 'delivery_partner#update_avilability'

  # Defines the root path route ("/")
  root "shipments#index"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

end
