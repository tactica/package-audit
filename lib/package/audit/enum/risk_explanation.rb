module Package
  module Audit
    module Enum
      module RiskExplanation
        POTENTIAL_DEPRECATION = 'no updates by author in over a year'
        OUTDATED_BY_MAJOR_VERSION = 'behind by a major version'
        OUTDATED = 'not at latest version'
        VULNERABILITY = 'security vulnerability'
      end
    end
  end
end
