class Authentication::JwtToken

  def self.encode(payload)
    return JWT.encode(payload, Rails.application.credentials.secret_key_base)
  end
  def self.decode(token)
    return JWT.decode(token, Rails.application.credentials.secret_key_base, true, algorithm: 'HS256')
  end
end