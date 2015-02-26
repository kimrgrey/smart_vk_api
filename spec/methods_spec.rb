require 'spec_helper'

describe SmartVkApi::VK do
  it { is_expected.to respond_to(:users, :wall, :photos, :friends, :audio, :groups) }

  describe 'method proxy' do
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
end