require 'spec_helper'

describe SmartVkApi::VK do
  it { is_expected.to respond_to(:users, :wall, :photos, :friends, :audio, :groups) }
  
  before do
    SmartVkApi.reset_configuration
  end
    
  describe 'methods proxy' do
    let (:vk) { SmartVkApi::VK.new }
    let (:default_response_body) { {:response => {:test => 'yes'} } }

    it 'should allow to call API methods using scope.method notation' do
      expect(vk.users).to respond_to(:get, :search, :report)
    end

    it 'should perform API request on method call' do
      stub_request(:get, "https://api.vk.com/method/users.get").to_return(:status => 200, :body => default_response_body.to_json)
      vk.users.get
      expect(WebMock).to have_requested(:get, "https://api.vk.com/method/users.get")
    end

    it 'should pass parameters to API request' do
      stub_request(:get, "https://api.vk.com/method/users.get?user_ids=kimrgrey").to_return(:status => 200, :body => default_response_body.to_json)
      vk.users.get({:user_ids => "kimrgrey"})
      expect(WebMock).to have_requested(:get, "https://api.vk.com/method/users.get?user_ids=kimrgrey")
    end
  end

  describe 'configuration' do
    it { is_expected.to respond_to(:configuration) }

    before do
      SmartVkApi.configure do |conf|
        conf.app_id = '0000000'
        conf.app_token = '7a6fa4dff77a228eeda56603'
        conf.access_token = '7a6fa4dff77a228eeda220349'
      end
    end
    
    it 'should use global configuration by default' do
      vk = SmartVkApi::VK.new
      expect(vk.configuration).to eq(SmartVkApi.configuration)
    end

    it 'should provide direct access to configuration fields' do
      vk = SmartVkApi::VK.new
      expect(vk.app_id).to eq('0000000')
      expect(vk.app_token).to eq('7a6fa4dff77a228eeda56603')
      expect(vk.access_token).to eq('7a6fa4dff77a228eeda220349')
    end

    it 'should be ready that configuration will be nil' do
      SmartVkApi.reset_configuration
      vk = SmartVkApi::VK.new
      expect(vk.configuration).to be nil
      expect(vk.app_id).to be nil
      expect(vk.app_token).to be nil
      expect(vk.access_token).to be nil
    end

    it 'should use specific configuration if is was given' do
      config = SmartVkApi::Configuration.new
      vk = SmartVkApi::VK.new(config)
      expect(vk.configuration).to eq(config)
    end
  end
end