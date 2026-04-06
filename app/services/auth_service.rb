class AuthService
  SECRET     = ENV.fetch('JWT_SECRET', 'fallback_secret_32_chars_minimum!')
  ACCESS_EXP  = 24 * 3600
  REFRESH_EXP = 30 * 24 * 3600

  def self.register(params)
    user = User.new(params)
    return { success: false, errors: user.errors.full_messages } unless user.save
    { success: true, data: { user: UserSerializer.new(user).as_json, **generate_tokens(user) } }
  end

  def self.login(email, password)
    user = User.find_by(email: email&.downcase)
    return { success: false, error: 'Invalid credentials' } unless user&.authenticate(password) && user.active?
    user.update_column(:last_login_at, Time.current)
    { success: true, data: { user: UserSerializer.new(user).as_json, **generate_tokens(user) } }
  end

  def self.decode_token(token)
    JWT.decode(token, SECRET, true, algorithm: 'HS256').first.symbolize_keys
  rescue JWT::ExpiredSignature => _e
    raise StandardError, 'Token expired'
  rescue JWT::DecodeError => e
    raise StandardError, "Invalid token: #{e.message}"
  end

  def self.refresh_token(token)
    payload = decode_token(token)
    user    = User.find(payload[:user_id])
    { success: true, data: generate_tokens(user) }
  rescue => e
    { success: false, error: e.message }
  end

  def self.generate_tokens(user)
    now = Time.now.to_i
    {
      access_token:  JWT.encode({ user_id: user.id, role: user.role, exp: now + ACCESS_EXP },  SECRET, 'HS256'),
      refresh_token: JWT.encode({ user_id: user.id, type: 'refresh', exp: now + REFRESH_EXP }, SECRET, 'HS256'),
      expires_in: ACCESS_EXP
    }
  end
end
