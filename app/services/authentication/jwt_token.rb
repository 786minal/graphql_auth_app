class Authentication::JwtToken

  def self.encode(payload)
    return JWT.encode(payload, Rails.application.credetials.secret_key_base)
  end
  def self.decode(token)
    return JWT.decode(token, Rails.application.credetials.secret_key_base, true, algorithm: 'HS256')
  end
end