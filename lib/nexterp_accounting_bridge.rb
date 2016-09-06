require "nexterp_accounting_bridge/version"
require "nexterp_accounting_bridge/core/core"
require "nexterp_accounting_bridge/entity/entity"

module NexterpAccountingBridge
  # Your code goes here...
  class << self
    def configure
      yield(Core::Credentials)
      Core::Client.instance
    end
  end
end
