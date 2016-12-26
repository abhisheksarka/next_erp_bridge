module NextErpBridge
  module Entity
    class Base
      @@klass_registry = { }

      include Core::Entry
      attr_accessor :attributes

      def initialize(attributes)
        @attributes = attributes
      end

      def method_missing(m, *args, &block)
        keys = attributes.keys.map(&:to_s)
        m = m.to_s
        is_setter = (m[-1] == '=')
        if is_setter
          m = m[0..(m.size-2)]
        end
        if keys.include?(m)
          attributes[m] = args[0] if is_setter
          attributes[m]
        else
          super(m.to_sym, *args)
        end
      end

      def self.klass_registry
        @@klass_registry
      end
    end
  end
end
