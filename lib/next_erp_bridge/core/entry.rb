require 'uri'
require 'active_support/core_ext'

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

        def encoded_doctype
          doctype
        end

        def create(attrs)
          Util.klass_wrap(self, client.insert(attrs.merge({
            doctype: encoded_doctype
          })))
        end

        def find(id)
          Util.klass_wrap(self, client.fetch_single_record({doctype: encoded_doctype, id: id}))
        end

        def find_by(params)
          filters = [[doctype]]
          params.each { | k, v | filters[0].concat([k.to_s, '=', v]) }
          res = client.fetch({ doctype: encoded_doctype }, filters)
          data = res['data']
          if data.present?
            find(data.first['name'])
          else
            data
          end
        end
      end

      module InstanceMethods
        attr_accessor :errors

        def client
          self.class.client
        end

        def doctype
          self.class.doctype
        end

        def encoded_doctype
          self.class.encoded_doctype
        end

        def update(attrs)
          attrs.merge!({ doctype: encoded_doctype, id: attributes['name'] })
          Util.instance_wrap(self, client.update(attrs))
        end

        def destroy
        end

        def save
          Util.instance_wrap(self, client.update(attributes.merge(id: attributes['name'], doctype: encoded_doctype)))
        end
      end
    end
  end
end
