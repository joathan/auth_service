# frozen_string_literal: true

# ApplicationController
class ApplicationController < ActionController::API
  SECRET_KEY = Rails.application.secrets.secret_key_base.to_s

  def encode_token(payload)
    JWT.encode(payload, SECRET_KEY)
  end

  def decode_token(token)
    JWT.decode(token, SECRET_KEY)[0]
  rescue StandardError
    nil
  end
end
