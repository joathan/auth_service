# frozen_string_literal: true

require 'jwt'

class JsonWebToken
  SECRET_KEY = ENV['SECRET_KEY_BASE']

  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY, 'HS256')
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY, true, { algorithm: 'HS256' })[0]
    HashWithIndifferentAccess.new(decoded)
  rescue JWT::ExpiredSignature
    Rails.logger.error 'Token has expired'
    nil
  rescue JWT::DecodeError => e
    Rails.logger.error "JWT Decode Error: #{e.message}"
    nil
  end
end
