module NexterpAccountingBridge
  module Entity
    class Base
      include Core::Entry
      def initialize
        client.login
      end
    end
  end
end
