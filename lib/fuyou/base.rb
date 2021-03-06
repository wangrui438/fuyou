module Fuyou
  module Base
    # 签名
    def sign(params)
      refresh_token
      options = {
        caCode: Fuyou.config.token,
        customId: Fuyou.config.custom_id,
        timeStamp: DateTime.now.utc.to_i,
        nonStr: SecureRandom.hex(10)
      }
      param = params.merge!(options)
      data = param.select { |_k, v| v.present? }.sort.map { |k, v| "#{k}=#{v}&" }.join
      sign = Digest::SHA1.hexdigest(data).upcase

      params.merge(sign: sign)
    end

    # POST 请求
    def http_post(action, params = {}, options = {})
      param = options[:skip_sign] ? params : sign(params)
      response = connection.post(action, param)
      format_response response
    end

    # GET 请求
    def http_get(action, params = {})
      param = sign(params)
      response = connection.get(action, param)
      format_response response
    end

    # 刷新token
    def refresh_token
      Fuyou::Ca.sign_in if Fuyou.config.expired_at.nil? || DateTime.now > Fuyou.config.expired_at
    end

    def connection
      Faraday.new(url: Fuyou.config.server, headers: nil) do |faraday|
        faraday.request :url_encoded
        faraday.response :logger, Fuyou.logger, bodies: true
        faraday.adapter Faraday.default_adapter
      end
    end

    # 处理接口响应
    def format_response(response)
      raise UnknownError, "福优网无法正常访问" if response.status != 200
      result = ActiveSupport::JSON.decode(response.body)
      raise InvalidResponseError, result['desc'] if result.is_a?(Hash) && result.key?('rcode') && result['rcode'] != '0000'
      result
    end
  end
end
