module Package
  module Audit
    module Formatter
      class Base
        def format
          raise NotImplementedError, 'Subclass must implement abstract method'
        end
      end
    end
  end
end
