# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Api::V1::Auth', type: :request do
  path '/api/v1/register' do
    post 'Register a new user' do
      tags 'Auth'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string, example: 'user@example.com' },
          password: { type: :string, example: 'password123' }
        },
        required: %w[email password]
      }

      response '201', 'User created successfully' do
        let(:user) { { email: Faker::Internet.email, password: 'password123' } }
        run_test!
      end

      response '422', 'Invalid parameters' do
        let(:user) { { email: '', password: '' } }
        run_test!
      end
    end
  end

  path '/api/v1/login' do
    post 'Login a user' do
      tags 'Auth'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :credentials, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string, example: 'user@example.com' },
          password: { type: :string, example: 'password123' }
        },
        required: %w[email password]
      }

      response '200', 'User logged in successfully' do
        let(:user) { create(:user, password: 'password123') }
        let(:credentials) { { email: user.email, password: 'password123' } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to have_key('token')
        end
      end

      response '401', 'Invalid credentials' do
        let(:user) { create(:user, password: 'password123') }
        let(:credentials) { { email: user.email, password: 'wrong_password' } }

        run_test!
      end
    end
  end

  path '/api/v1/verify_token' do
    get 'Verify user token' do
      tags 'Auth'
      produces 'application/json'
      parameter name: :Authorization, in: :header, type: :string, required: true

      response '200', 'Token is valid' do
        let(:user) { create(:user) }
        let(:Authorization) { "Bearer #{JsonWebToken.encode(user_id: user.id)}" }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['user_id']).to eq(user.id)
        end
      end

      response '401', 'Token is invalid' do
        let(:Authorization) { 'Bearer invalid_token' }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['error']).to eq('Invalid or expired token')
        end
      end

      response '401', 'Token is expired' do
        let(:Authorization) do
          expired_token = JsonWebToken.encode({ user_id: 1 }, 1.second.ago)
          "Bearer #{expired_token}"
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['error']).to eq('Invalid or expired token')
        end
      end
    end
  end
end