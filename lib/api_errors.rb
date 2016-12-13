class ApiErrors
  @@error_keys = {
    'Password is too short (minimum is 6 characters)' => :password_too_short,
    'Password is missing'                               => :password_blank,
    'Email is missing'                                  => :email_blank,
    'Email is invalid'                                      => :email_invalid,
    'Email has already been taken'                          => :email_taken,
    'Invalid or expired token'                              => :invalid_token,
    'Your credentials do not allow access to this resource' => :forbidden,
    'The requested resource was not found on the server'    => :not_found,
    'Internal Server Error'                                 => :internal_server_error,
    'We could not sign you in through Facebook. Maybe the email address you used to sign up with Facebook is invalid? You may try creating an account and then linking it with your Facebook account later.' => :facebook_signin_failed
  }

  def self.hash_for_message(message)
    key = @@error_keys.fetch(message, 'undefined_error_type')
    hash_for_key_and_message(key, message)
  end

  def self.hash_for_key(key)
    message = (@@error_keys.rassoc(key)[0] or 'undefined_error_message')
    hash_for_key_and_message(key, message)
  end

  private

  def self.hash_for_key_and_message(key, message)
    { error: key, error_description: message }
  end
end
