module NextErpBridge
  module Core
    module Doctypes
      @supported = {
        Customer: 'Customer',
        Supplier: 'Supplier',
        Journal: 'Journal',
        PurchaseOrder: 'Purchase%20Order',
        SupplierQuotation: 'Supplier%20Quotation'
      }

      def self.supported
        @supported
      end
    end
  end
end
