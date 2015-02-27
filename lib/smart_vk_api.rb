require 'net/http'
require 'json'

module SmartVkApi
  autoload :Constants, "smart_vk_api/constants"
  autoload :Call, "smart_vk_api/call"
  autoload :Methods, "smart_vk_api/methods"

  class MethodCallError < StandardError; end;

  class VK
    include SmartVkApi::Call
    include SmartVkApi::Methods
  end
end