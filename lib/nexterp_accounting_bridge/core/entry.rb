module NexterpAccountingBridge
  module Core
    module Entry
      def self.included(base)
        base.send(:extend, ClassMethods)
        base.send(:include, InstanceMethods)
      end

      module ClassMethods
        def create
        end

        def find(id=nil)
        end
      end

      module InstanceMethods
        def update
        end

        def destroy
        end
      end
    end
  end
end
