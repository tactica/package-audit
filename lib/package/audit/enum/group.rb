module Package
  module Audit
    module Enum
      module Group
        DEV = 'development'
        TEST = 'test'
        STAGING = 'staging'
        PRODUCTION = 'production'
        DEFAULT = 'default'

        def self.all
          constants.map { |key| Enum::Group.const_get(key) }.sort
        end
      end
    end
  end
end
