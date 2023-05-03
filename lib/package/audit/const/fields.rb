module Package
  module Audit
    module Const
      module Fields
        ALL = %i[
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

        REPORT = %i[name version latest_version latest_version_date groups vulnerabilities risk_type risk_explanation]
        VULNERABLE = %i[name version latest_version groups vulnerabilities]
        OUTDATED = %i[name version latest_version latest_version_date groups]

        # the names of these fields must match the instance variables in the Dependency class
        HEADERS = {
          name: 'Package',
          version: 'Version',
          version_date: 'Date',
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
