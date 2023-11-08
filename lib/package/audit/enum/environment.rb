module Package
  module Audit
    module Enum
      module Environment
        DEV = 'development'
        TEST = 'test'
        STAGING = 'staging'
        PRODUCTION = 'production'
        DEFAULT = 'default'

        def self.all
          constants.map { |key| Enum::Environment.const_get(key) }.sort
        end
      end
    end
  end
end
