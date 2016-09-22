module NextErpBridge
  module Core
    module Util
      def self.instance_create(klass, res, attrs=nil)
        if res['data']
          instance = klass.new(res['data'])
        else
          instance = klass.new(attrs)
          instance.errors = res['exc']
        end
        instance
      end

      def self.instance_update(instance, res)
        if res['data']
          instance.errors = nil
          instance.attributes = res['data']
        else
          instance.errors = res['exc']
        end
        instance
      end
    end
  end
end
