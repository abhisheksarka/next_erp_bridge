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
        registry = Base.klass_registry

        # Check if the class has been created already
        # This is to prevent creation of multiple
        # versions of the same class object
        klass = registry[doctype_name]

        # If it is not present create an anonymous class
        # and add it to the registry
        if klass.blank?
          klass = Class.new(Base) do
            
          end
          registry[doctype_name] = klass
        end

        # Do stuff on the class and return the class instance
        klass.instance_variable_set(:@doctype, doctype_name)
        klass
      else
        super
      end
    end
  end
end
