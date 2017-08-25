module Fuyou
  class Ca
    extend Fuyou::Base

    class << self
      # CA 签到
      def sign_in
        pfx_string = read_pfx_string
        ca_key = Digest::MD5.hexdigest(Fuyou.config.ca_key)
        password_key = Digest::MD5.hexdigest(Fuyou.config.password_key)

        options = {
          pfxstr: des_encrypt(pfx_string, ca_key),
          customId: Fuyou.config.custom_id,
          password: des_encrypt(Fuyou.config.ca_password, password_key)
        }

        response = http_post('/FuyouRest/sign/signIn', options, skip_sign: true)
        Fuyou.config.token = response['data']['key']
      end

      # CA 签退
      def sign_out
        http_post('/FuyouRest/sign/signOut', customId: Fuyou.config.custom_id, skip_sign: true)
      end

      private

      # 读取pfx证书的内容
      # 内容使用base64编码
      def read_pfx_string
        raw = File.read(Fuyou.config.certificate_path)
        pkcs = OpenSSL::PKCS12.new raw, Fuyou.config.ca_password
        Base64.encode64(pkcs.certificate.to_pem)
      end

      # DES 加密
      def des_encrypt(des_text, des_key)
        des = OpenSSL::Cipher::Cipher.new("DES-ECB")
        des.encrypt
        des.key = des_key
        result = des.update(des_text)
        result << des.final
      end
    end
  end
end
