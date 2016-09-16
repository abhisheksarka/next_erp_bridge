require 'frappe/client'
require 'singleton'

module NextErpBridge
  module Core
    class Client
      include Singleton

      attr_accessor :frappe_client,
                    :credentials

      def initialize
        @credentials = Credentials
        @frappe_client = Frappe::Client::FrappeClient.new(
                          credentials.host,
                          credentials.username,
                          credentials.password
                        )
      end

      def login
        @frappe_client.login(credentials.username, credentials.password)
      end
    end
  end
end
