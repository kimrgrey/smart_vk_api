module SmartVkApi
  module Methods
    def method_missing(method_name, *arguments, &block)
      Proxy.new(self, method_name)
    end

    def respond_to?(method_name, include_private = false)
      true # we should respond to any method using Proxy
    end

    class Proxy
      attr_accessor :vk
      attr_accessor :scope

      def self.camelcase(method_name)
        result = method_name.to_s.split('_').map(&:capitalize).join
        result[0] = result[0].downcase
        result
      end

      def initialize(vk, scope)
        self.vk = vk
        self.scope = scope
      end

      def method_missing(method_name, *arguments, &block)
        method_name = Proxy.camelcase(method_name)
        vk.call("#{scope}.#{method_name}", arguments.first)
      end

      def respond_to?(method_name, include_private = false)
        true # we should respond to any method using Proxy
      end
    end
  end
end
