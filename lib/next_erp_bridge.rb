require "next_erp_bridge/version"
require "next_erp_bridge/core/core"
require "next_erp_bridge/entity/entity"

module NextErpBridge
  # Your code goes here...
  class << self
    def configure
      yield(Core::Credentials)
      Core::Client.instance
    end
  end
end
