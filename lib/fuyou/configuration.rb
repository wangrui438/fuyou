module Fuyou
  class Configuration
    attr_accessor :server, :certificate_path, :ca_key, :ca_password, :password_key, :custom_id, :custom_source
    attr_accessor :token, :expired_at
  end
end
