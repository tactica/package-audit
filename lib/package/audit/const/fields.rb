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

        DEFAULT = %i[name version latest_version latest_version_date groups vulnerabilities risk_type risk_explanation]

        # the names of these fields must match the instance variables in the Dependency class
        HEADERS = {
          name: 'Package',
          version: 'Version',
          version_date: 'Version Date',
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
