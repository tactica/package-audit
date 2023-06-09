module Package
  module Audit
    module Const
      module Fields
        AVAILABLE = %i[
          name
          version
          version_date
          latest_version
          latest_version_date
          groups
          vulnerabilities
          risk_type
          risk_explanation
        ]

        ALL = %i[name version latest_version latest_version_date groups vulnerabilities risk_type risk_explanation]
        DEPRECATED = %i[name version latest_version latest_version_date groups]
        OUTDATED = %i[name version latest_version latest_version_date groups]
        VULNERABLE = %i[name version latest_version groups vulnerabilities]

        # the names of these fields must match the instance variables in the Dependency class
        HEADERS = {
          name: 'Package',
          version: 'Version',
          latest_version: 'Latest',
          latest_version_date: 'Latest Date',
          groups: 'Groups',
          vulnerabilities: 'Vulnerabilities',
          risk_type: 'Risk',
          risk_explanation: 'Risk Explanation'
        }
      end
    end
  end
end
