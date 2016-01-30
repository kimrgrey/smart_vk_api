require 'spec_helper'

describe SmartVkApi do

  describe 'call' do
    it { is_expected.to respond_to(:vk) }
    it { is_expected.to respond_to(:call) }

    it 'should delegate call to VK instance' do
      vk = SmartVkApi.vk
      allow(SmartVkApi).to receive(:vk) { vk }
      expect(vk).to receive(:call)
      SmartVkApi.call('users.get', {:user_ids => 'kimrgrey'})
    end
  end

  describe 'configuration' do
    it { is_expected.to respond_to(:configure) }

    before do
      SmartVkApi.configure do |conf|
        conf.app_id = '0000000'
        conf.app_token = '7a6fa4dff77a228eeda56603'
      end
    end

    it 'should allow to reset configuration' do
      SmartVkApi.reset_configuration
      expect(SmartVkApi.configuration).to be nil
    end

    it 'should allow to read global configuration' do
      expect(SmartVkApi.configuration.app_id).to eq('0000000')
      expect(SmartVkApi.configuration.app_token).to eq('7a6fa4dff77a228eeda56603')
    end
  end
end
