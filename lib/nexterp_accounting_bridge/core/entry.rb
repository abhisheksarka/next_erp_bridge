module NexterpAccountingBridge
  module Core
    module Entry

      def self.included(base)
        base.send(:extend, ClassMethods)
        base.send(:include, InstanceMethods)
      end

      module ClassMethods
        def client
          Client.instance.frappe_client
        end

        def doctype
          @doctype
        end

        def create(attrs)
          attrs.merge!({
            doctype: doctype
          })
          Util.klass_wrap(self, client.insert(attrs))
        end

        def find(id)
          attrs = {
            doctype: doctype,
            id: id
          }
          Util.klass_wrap(self, client.fetch_single_record(attrs))
        end
      end

      module InstanceMethods
        def client
          self.class.client
        end

        def doctype
          self.class.doctype
        end

        def update(attrs)
          attrs.merge!({
            doctype: doctype,
            id: attributes['name']
          })
          Util.instance_wrap(self, client.update(attrs))
        end

        def destroy
        end
      end
    end
  end
end
