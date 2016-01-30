module SmartVkApi
  module Methods
    def method_missing(method_name, *arguments, &block)
      Proxy.new(self, method_name)
    end

    def respond_to?(method_name, include_private = false)
      true # we should respond to any method using Proxy
    end

    PREDEFINED_METHODS = {
      'users' => [
        'get', 'search', 'isAppUser', 'getSubscriptions', 'getFollowers', 'report', 'getNearby'
      ]
    }

    PREDEFINED_METHODS.each_key do |scope_name|
      define_method scope_name do
        Proxy.new(self, scope_name)
      end
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
        predefine_methods!
      end

      def method_missing(method_name, *arguments, &block)
        method_name = Proxy.camelcase(method_name)
        vk.call("#{scope}.#{method_name}", arguments.first)
      end

      def respond_to?(method_name, include_private = false)
        true # we should respond to any method using Proxy
      end

      private

      def predefine_methods!
        method_names = SmartVkApi::Methods::PREDEFINED_METHODS[scope.to_s]
        return if method_names.nil?
        method_names.each do |method_name|
          define_singleton_method method_name do |arg = nil|
            vk.call("#{scope}.#{method_name}", arg)
          end
        end
      end
    end
  end
end
