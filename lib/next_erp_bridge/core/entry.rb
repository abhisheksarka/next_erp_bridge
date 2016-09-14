module NextErpBridge
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
          Util.klass_wrap(self, client.insert(attrs.merge({
            doctype: doctype
          })))
        end

        def find(id)
          Util.klass_wrap(self, client.fetch_single_record({doctype: doctype, id: id}))
        end

        def find_by(params)
          filters = [[doctype]]
          params.each { | k, v | filters[0].concat([k, '=', v]) }
          res = client.fetch({ doctype: doctype }, filters)
          data = res['data']
          if data
            find(data.last['name'])
          else
            res
          end
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
          attrs.merge!({ doctype: doctype,id: attributes['name'] })
          Util.instance_wrap(self, client.update(attrs))
        end

        def destroy
        end

        def save
          Util.instance_wrap(self, client.update(attributes.merge(id: attributes['name'], doctype: attributes['doctype'])))
        end
      end
    end
  end
end
