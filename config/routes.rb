# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'register', to: 'auth#register'
      post 'login', to: 'auth#login'
    end
  end

  get 'up' => 'rails/health#show', as: :rails_health_check
end
