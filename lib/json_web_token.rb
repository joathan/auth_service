# frozen_string_literal: true

require 'jwt'

class JsonWebToken
  SECRET_KEY = Rails.application.secrets.secret_key_base.to_s

  # Método para codificar o payload
  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  # Método para decodificar o token
  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new(decoded)
  rescue JWT::ExpiredSignature
    Rails.logger.error 'Token has expired'
    nil
  rescue JWT::DecodeError => e
    Rails.logger.error "JWT Decode Error: #{e.message}"
    nil
  end
end
