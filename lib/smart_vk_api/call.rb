module SmartVkApi
  module Call
    def call(method_name, params = {})
      http(method_name, params) do |response|
        raise SmartVkApi::MethodCallError, response.body unless response.is_a?(Net::HTTPSuccess)
        json = response.body
        raise SmartVkApi::MethodCallError, 'Response could not be empty' if json.nil? || json.empty?
        parsed_json = JSON.parse(json, :symbolize_names => true)
        raise SmartVkApi::MethodCallError, json if is_error?(parsed_json)
        raise SmartVkApi::MethodCallError, 'Response should include key named :response' unless parsed_json.has_key?(:response)
        parsed_json[:response]
      end
    end

    def http(method_name, params = {})
      uri = URI(method_url(method_name, params))
      http = Net::HTTP.new(uri.host,uri.port)
      http.use_ssl = true
      block_given? ? yield(http.get(uri.request_uri, headers)) : http
    end

    def method_url(method_name, params = {})
      if method_name.nil? || method_name.empty?
        raise ArgumentError, 'Method name could not be empty'
      end
      if access_token && (params.nil? || !params.key?(:access_token))
        params ||= {}
        params[:access_token] = access_token
      end
      url = SmartVkApi::Constants::METHOD_CALL_URL + "/#{method_name}"
      url += "?#{URI.encode_www_form(params)}" if params && params.any?
      url
    end

    protected

    def is_error?(parsed_json)
      parsed_json.has_key?(:error)
    end

    def headers
      {
        'Accept' => 'application/json',
        'Content-Type' =>'application/json'
      }
    end
  end
end