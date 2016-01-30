require 'spec_helper'

describe SmartVkApi::VK do
  it { should respond_to(:call) }
  it { should respond_to(:method_url) }
  it { should respond_to(:http) }

  let (:vk) { SmartVkApi::VK.new }
  let (:default_response_body) { {:response => {:test => 'yes'} } }

  before do
    SmartVkApi.reset_configuration
  end

  describe '#method_url' do
    context 'without access token' do
      it 'should raise ArgumentError when method name is nil' do
        expect{ vk.method_url(nil) }.to raise_error(ArgumentError, 'Method name could not be empty')
      end

      it 'should raise ArgumentError when method name is empty string' do
        expect{ vk.method_url('') }.to raise_error(ArgumentError, 'Method name could not be empty')
      end

      it 'should take care of method name' do
        expect(vk.method_url('users.get')).to eq('https://api.vk.com/method/users.get')
      end

      it 'should take care of parameters' do
        expect(vk.method_url('users.get', {:aaa => :bbb, :user_ids => :kimrgrey})).to eq('https://api.vk.com/method/users.get?aaa=bbb&user_ids=kimrgrey')
      end
    end

    context 'with access token' do
      it 'should add access token when no parameters given' do
        expect(vk.method_url('users.get', :access_token => '7a6fa4dff77a228eeda56603')).to eq('https://api.vk.com/method/users.get?access_token=7a6fa4dff77a228eeda56603')
      end

      it 'should use access token from configuration by default' do
        SmartVkApi.configure do |conf|
          conf.access_token = '7a6fa4dff77a228eeda56603'
        end
        expect(vk.method_url('users.get')).to eq('https://api.vk.com/method/users.get?access_token=7a6fa4dff77a228eeda56603')
      end

      it 'should use specified access token if it was given' do
        SmartVkApi.configure do |conf|
          conf.access_token = '7a6fa4dff77a228eeda56603'
        end
        expect(vk.method_url('users.get', :access_token => '7a6fa4dff77a228eeda56604')).to eq('https://api.vk.com/method/users.get?access_token=7a6fa4dff77a228eeda56604')
      end
    end
  end

  describe '#http' do
    it 'should return http connection if block was not given' do
      expect( vk.http('users.get')).to be_a(Net::HTTP)
    end

    it 'should return result of block call if block was given' do
      stub_request(:get, "https://api.vk.com/method/users.get").to_return(:status => 200, :body => default_response_body.to_json)
      expect( vk.http('users.get') { |_| 'result of block' }).to eq('result of block')
    end

    it 'should pass http connection as parameter into block' do
      stub_request(:get, "https://api.vk.com/method/users.get").to_return(:status => 200, :body => default_response_body.to_json)
      expect(vk.http('users.get') { |http| http }).to be_a(Net::HTTPResponse)
    end

    it 'should setup appropriate headers' do
      headers = {
        'Content-Type' =>'application/json',
        'Content-Type' =>'application/json'
      }
      stub_request(:get, "https://api.vk.com/method/users.get").to_return(:status => 200, :body => default_response_body.to_json)
      vk.call('users.get')
      expect(WebMock).to have_requested(:get, "https://api.vk.com/method/users.get").with(:headers => headers)
    end
  end

  describe '#call' do
    it 'should send request to appropriate url according to method name' do
      stub_request(:get, "https://api.vk.com/method/users.get").to_return(:status => 200, :body => default_response_body.to_json)
      vk.call('users.get')
      expect(WebMock).to have_requested(:get, "https://api.vk.com/method/users.get")
    end

    it 'should send request to appropriate url according params' do
      stub_request(:get, "https://api.vk.com/method/users.get?user_ids=kimrgrey").to_return(:status => 200, :body => default_response_body.to_json)
      vk.call('users.get', {:user_ids => 'kimrgrey'})
      expect(WebMock).to have_requested(:get, "https://api.vk.com/method/users.get?user_ids=kimrgrey")
    end

    it 'should return raise MethodCallError if body of response is nil' do
      stub_request(:get, "https://api.vk.com/method/users.get").to_return(:status => 200, :body => nil)
      expect { vk.call('users.get') }.to raise_error(SmartVkApi::MethodCallError, 'Response could not be empty')
    end

    it 'should return raise MethodCallError if body of response is empty string' do
      stub_request(:get, "https://api.vk.com/method/users.get").to_return(:status => 200, :body => "")
      expect { vk.call('users.get') }.to raise_error(SmartVkApi::MethodCallError, 'Response could not be empty')
    end

    it 'should return raise MethodCallError if body of response has no key :response' do
      stub_request(:get, "https://api.vk.com/method/users.get").to_return(:status => 200, :body => { :bad => :response }.to_json)
      expect { vk.call('users.get') }.to raise_error(SmartVkApi::MethodCallError, 'Response should include key named :response')
    end

    it 'should raise MethodCallError error in case of internal server error' do
      stub_request(:get, "https://api.vk.com/method/users.get").to_return(:status => 500, :body => 'Internal Server Error')
      expect { vk.call('users.get') }.to raise_error(SmartVkApi::MethodCallError, 'Internal Server Error')
    end

    it 'should raise MethodCallError in case of method call error' do
      response = { :error => { :error_code => 113, :error_msg => 'Invalid user id' } }
      stub_request(:get, "https://api.vk.com/method/users.get").to_return(:status => 200, :body => response.to_json)
      expect { vk.call('users.get') }.to raise_error(SmartVkApi::MethodCallError, response.to_json)
    end

    it 'should return value of :response key of returned json' do
      stub_request(:get, "https://api.vk.com/method/users.get").to_return(:status => 200, :body => default_response_body.to_json)
      expect(vk.call('users.get')).to eq(default_response_body[:response])
    end
  end
end
