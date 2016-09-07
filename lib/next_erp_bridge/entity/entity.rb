require_relative './base'

module NextErpBridge
  module Entity
    ##
    # Dynamically creates class to access the ERP API
    #
    # Class and doctype should be defined in Core::Doctypes.supported
    #
    # If defined, you can call methods 'create', 'update', 'destroy' and 'find'
    #
    # For e.g NextErpBridge::Entity::Journal.create(attrs) assuming
    # Journal is defined in Core::Doctypes.supported
    #
    # If basic CRUD is not enough on the class(Journal in this case) you can create
    # a new class of inside the Entity module and inherit the base class and define a
    # doctype on it and other methods needed
    #
    # module NextErpBridge
    #   module Entity
    #     class Journal < Base
    #       @doctype = 'Journal%20Entry'
    #       def some_custom_method
    #       end
    #     end
    #   end
    # end
    #
    ##

    def self.const_missing(name)
      klass_name = name
      doctype_name = Core::Doctypes.supported[klass_name]
      if doctype_name
        klass = Class.new(Base)
        klass.instance_variable_set(:@doctype, doctype_name)
        klass
      else
        super
      end
    end
  end
end
