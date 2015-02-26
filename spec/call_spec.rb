require 'spec_helper'

describe SmartVkApi::VK do
  it { should respond_to(:call) }
  it { should respond_to(:method_url) }
  it { should respond_to(:http) }

  let (:vk) { SmartVkApi::VK.new }
  let (:default_response_body) { {:response => {:test => 'yes'} } }

  describe '#method_url' do
    it 'should raise ArgumentError when method name is nil' do
      expect{ vk.method_url(nil) }.to raise_error(ArgumentError, 'Method name could not be empty')
    end
    
    it 'should raise ArgumentError when method name is empty string' do
      expect{ vk.method_url('') }.to raise_error(ArgumentError, 'Method name could not be empty')
    end
    
    it 'should take care of method name' do
      expect(vk.method_url('scope.method')).to eq('https://api.vk.com/method/scope.method')
    end

    it 'should take care of parameters' do
      expect(vk.method_url('scope.method', {:aaa => :bbb, :xxx => :yyy})).to eq('https://api.vk.com/method/scope.method?aaa=bbb&xxx=yyy')
    end
  end

  describe '#http' do
    it 'should return http connection if block was not given' do
      expect( vk.http('scope.method')).to be_a(Net::HTTP)
    end
    
    it 'should return result of block call if block was given' do
      stub_request(:get, "https://api.vk.com/method/scope.method").to_return(:status => 200, :body => default_response_body.to_json)
      expect( vk.http('scope.method') { |_| 'result of block' }).to eq('result of block')
    end

    it 'should pass http connection as parameter into block' do
      stub_request(:get, "https://api.vk.com/method/scope.method").to_return(:status => 200, :body => default_response_body.to_json)
      expect(vk.http('scope.method') { |http| http }).to be_a(Net::HTTPResponse)
    end

    it 'should setup appropriate headers' do
      headers = {
        'Content-Type' =>'application/json',
        'Content-Type' =>'application/json'
      }
      stub_request(:get, "https://api.vk.com/method/scope.method").to_return(:status => 200, :body => default_response_body.to_json)
      vk.call('scope.method')
      expect(WebMock).to have_requested(:get, "https://api.vk.com/method/scope.method").with(:headers => headers)
    end
  end

  describe '#call' do
    it 'should send request to appropriate url according to method name' do
      stub_request(:get, "https://api.vk.com/method/scope.method").to_return(:status => 200, :body => default_response_body.to_json)
      vk.call('scope.method')
      expect(WebMock).to have_requested(:get, "https://api.vk.com/method/scope.method")
    end

    it 'should send request to appropriate url according params' do
      stub_request(:get, "https://api.vk.com/method/scope.method?xxx=yyy").to_return(:status => 200, :body => default_response_body.to_json)
      vk.call('scope.method', {:xxx => 'yyy'})
      expect(WebMock).to have_requested(:get, "https://api.vk.com/method/scope.method?xxx=yyy")
    end

    it 'should return raise MethodCallError if body of response is nil' do
      stub_request(:get, "https://api.vk.com/method/scope.method").to_return(:status => 200, :body => nil)
      expect { vk.call('scope.method') }.to raise_error(SmartVkApi::MethodCallError, 'Response could not be empty')
    end

    it 'should return raise MethodCallError if body of response is empty string' do
      stub_request(:get, "https://api.vk.com/method/scope.method").to_return(:status => 200, :body => "")
      expect { vk.call('scope.method') }.to raise_error(SmartVkApi::MethodCallError, 'Response could not be empty')
    end

    it 'should return raise MethodCallError if body of response has no key :response' do
      stub_request(:get, "https://api.vk.com/method/scope.method").to_return(:status => 200, :body => { :bad => :response }.to_json)
      expect { vk.call('scope.method') }.to raise_error(SmartVkApi::MethodCallError, 'Response should include key named :response')
    end

    it 'should raise MethodCallError error in case of internal server error' do
      stub_request(:get, "https://api.vk.com/method/scope.method").to_return(:status => 500, :body => 'Internal Server Error')
      expect { vk.call('scope.method') }.to raise_error(SmartVkApi::MethodCallError, 'Internal Server Error')
    end

    it 'should raise MethodCallError in case of method call error' do
      response = { :error => { :error_code => 113, :error_msg => 'Invalid user id' } }
      stub_request(:get, "https://api.vk.com/method/scope.method").to_return(:status => 200, :body => response.to_json)
      expect { vk.call('scope.method') }.to raise_error(SmartVkApi::MethodCallError, response.to_json)
    end

    it 'should return value of :response key of returned json' do
      stub_request(:get, "https://api.vk.com/method/scope.method").to_return(:status => 200, :body => default_response_body.to_json)
      expect(vk.call('scope.method')).to eq(default_response_body[:response])
    end
  end
end