module NexterpAccountingBridge
  module Entity
    class Journal
      include Core::Entry

      def self.doctype
        'Journal'
      end
    end
  end
end
