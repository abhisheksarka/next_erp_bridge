require 'frappe/client'
require_relative './entry'
module NextErpBridge
  module Core
    class Credentials
      @host = nil
      @username = nil
      @pasword = nil

      class << self
        attr_accessor :host, :username, :password
      end
    end
  end
end
