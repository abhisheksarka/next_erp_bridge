module NextErpBridge
  module Core
    module Util
      def self.klass_wrap(klass, res)
        if res['data']
          klass.new(res['data'])
        else
          res['exc']
        end
      end

      def self.instance_wrap(instance, res)
        if res['data']
          instance.errors = nil
          instance.attributes = res['data']
        else
          instance.errors = res['exc']
          false
        end
      end
    end
  end
end
