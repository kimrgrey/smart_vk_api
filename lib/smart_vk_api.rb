require 'net/http'
require 'json'

module SmartVkApi
  autoload :Constants, "smart_vk_api/constants"
  autoload :Call, "smart_vk_api/call"
  autoload :Methods, "smart_vk_api/methods"
  autoload :Configuration, "smart_vk_api/configuration"

  class MethodCallError < StandardError; end;

  class VK
    include SmartVkApi::Call
    include SmartVkApi::Methods

    def initialize(configuration = nil)
      @configuration = configuration
    end

    def configuration
      @configuration || SmartVkApi.configuration
    end

    def access_token
      configuration.access_token unless configuration.nil?
    end

    def app_id
      configuration.app_id unless configuration.nil?
    end

    def app_token
      configuration.app_token unless configuration.nil?
    end
  end

  class << self
    attr_accessor :configuration
  end

  def self.reset_configuration
    self.configuration = nil
  end

  def self.configure
    self.configuration ||= SmartVkApi::Configuration.new
    yield(configuration)
  end

  def self.vk
    SmartVkApi::VK.new
  end

  def self.call(method_name, params = {})
    vk.call(method_name, params)
  end
end