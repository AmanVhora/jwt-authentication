require 'jwt'

module JwtToken
  extend ActiveSupport::Concern
  
  RSA_PRIVATE = OpenSSL::PKey::RSA.generate 2048
  RSA_PUBLIC = RSA_PRIVATE.public_key

  def jwt_encode(payload)
    JWT.encode(payload, RSA_PRIVATE, 'RS256')
  end

  def jwt_decode(token)
    decoded = JWT.decode(token, RSA_PUBLIC, true, { algorithm: 'RS256' })
    HashWithIndifferentAccess.new decoded
  end
end
