module NexterpAccountingBridge
  module Core
    module Entry

      def self.included(base)
        base.send(:extend, ClassMethods)
        base.send(:include, InstanceMethods)
      end

      module ClassMethods
        def create(data)
          data[:doctype] = doctype
          res = client.insert(data)
          if res['data']
            self.new(res['data'])
          else
            res['exc']
          end
        end

        def find(id=nil)
        end

        def client
          Client.instance.frappe_client
        end

        def doctype
          @doctype
        end
      end

      module InstanceMethods
        def update
        end

        def destroy
        end

        def client
          self.class.client
        end

        def doctype
          self.class.doctype
        end
      end
    end
  end
end
