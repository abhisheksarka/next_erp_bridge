require 'uri'
require 'active_support'
require 'active_support/core_ext'

module NextErpBridge
  module Core
    module Entry

      def self.included(base)
        base.send(:extend, ClassMethods)
        base.send(:include, InstanceMethods)
      end

      module ClassMethods
        # All methods call this so that we can do a login
        # before we actually start CRUD in the ERP
        # As of now for every call it is calling login
        # which is bad
        # TODO: Need to change this to, login when session expires
        def before_action(c={login: true})
          Client.instance.login if c[:login]
        end

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
          before_action

          a = attrs.merge({
            doctype: encoded_doctype
          })
          Util.instance_create(self, client.insert(a), a)
        end

        def find(id, do_login=true)
          before_action(login: do_login)

          res = client.fetch_single_record({doctype: encoded_doctype, id: id})
          d = res['data']
          self.new(d) if d.present?
        end

        def all(limit_start=0, limit_page_length=0, do_login=true)
          before_action(login: do_login)
          res = client.fetch({doctype: encoded_doctype}, [ ], ["*"], limit_start, limit_page_length)
          res['data'].map { | r | self.new(r) }
        end

        def find_by(params)
          before_action

          filters = [[doctype]]
          params.each { | k, v | filters[0].concat([k.to_s, '=', v]) }
          res = client.fetch({ doctype: encoded_doctype }, filters)
          data = res['data']
          if data.present?
            find(data.first['name'], false)
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

        def before_action
          self.class.before_action
        end

        def doctype
          self.class.doctype
        end

        def encoded_doctype
          self.class.encoded_doctype
        end

        def update(attrs)
          before_action

          attrs.merge!({ doctype: encoded_doctype, id: attributes['name'] })
          Util.instance_update(self, client.update(attrs))
          !errors.present?
        end

        def destroy
        end

        def save
          before_action

          Util.instance_update(self, client.update(attributes.merge(id: attributes['name'], doctype: encoded_doctype)))
          !errors.present?
        end
      end
    end
  end
end
