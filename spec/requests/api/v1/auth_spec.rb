# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Auth', type: :request do
  describe 'POST /api/v1/register' do
    it 'creates a new user with valid parameters' do
      post '/api/v1/register', params: { email: Faker::Internet.email, password: 'password123' }

      expect(response).to have_http_status(:created)
    end

    it 'returns error for invalid registration' do
      post '/api/v1/register', params: { email: '', password: '' }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'POST /api/v1/login' do
    let(:user) { create(:user) }

    it 'logs in a user with valid credentials' do
      post '/api/v1/login', params: { email: user.email, password: 'password123' }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to have_key('token')
    end

    it 'returns error for invalid login' do
      post '/api/v1/login', params: { email: user.email, password: 'wrong_password' }

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
