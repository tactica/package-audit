module Package
  module Audit
    module Enum
      module Technology
        NODE = 'node'
        RUBY = 'ruby'

        def self.all
          constants.map { |key| Enum::Technology.const_get(key) }.sort
        end
      end
    end
  end
end
