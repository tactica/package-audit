module Package
  module Audit
    module Enum
      module Format
        CSV = 'csv'
        MD = 'md'

        def self.all
          constants.map { |key| const_get(key) }.sort
        end
      end
    end
  end
end
