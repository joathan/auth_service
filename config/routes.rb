# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  namespace :api do
    namespace :v1 do
      post 'register', to: 'auth#register'
      post 'login', to: 'auth#login'
      get 'verify_token', to: 'auth#verify_token'
    end
  end

  get 'up' => 'rails/health#show', as: :rails_health_check
end
