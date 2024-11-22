# frozen_string_literal: true

# AuthController
module Api
  module V1
    class AuthController < ApplicationController
      def register
        user = User.new(user_params)
        if user.save
          render json: { message: 'User created successfully' }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end
    
      def login
        user = User.find_by(email: params[:email])

        if user&.authenticate(params[:password])
          token = JsonWebToken.encode(user_id: user.id)

          headers['Set-Cookie'] = "auth_token=#{token}; HttpOnly; Secure=#{Rails.env.production?}; SameSite=Lax"

          render json: { token: token }, status: :ok
        else
          render json: { error: 'Invalid email or password' }, status: :unauthorized
        end
      end

      def verify_token
        token = request.headers['Authorization']&.split(' ')&.last
        decoded_token = JsonWebToken.decode(token)

        if decoded_token && decoded_token[:user_id]
          user = User.find_by(id: decoded_token[:user_id])
          if user
            render json: { user_id: user.id }, status: :ok
          else
            render json: { error: 'User not found' }, status: :unauthorized
          end
        else
          render json: { error: 'Invalid or expired token' }, status: :unauthorized
        end
      end

      private
    
      def user_params
        params.require(:auth).permit(:email, :password)
      end
    end
  end
end
