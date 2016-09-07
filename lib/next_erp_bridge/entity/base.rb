module NextErpBridge
  module Entity
    class Base
      include Core::Entry
      attr_accessor :attributes

      def initialize(attributes)
        @attributes = attributes
      end
    end
  end
end
