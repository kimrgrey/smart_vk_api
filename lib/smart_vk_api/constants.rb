module SmartVkApi
  module Constants
    API_URL = "https://api.vk.com".freeze
    METHOD_CALL_URL = "#{SmartVkApi::Constants::API_URL}/method".freeze
    METHOD_NAME_REGEXP = /\A([a-z,A-Z]+)\.([a-z,A-Z]+)\Z/
  end
end