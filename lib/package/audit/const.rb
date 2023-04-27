module Const
  SECONDS_PER_YEAR = 31_556_952 # length of a gregorian year (365.2425 days)
  YEARS_ELAPSED_TO_BE_OUTDATED = 2
  SECONDS_ELAPSED_TO_BE_OUTDATED = SECONDS_PER_YEAR * YEARS_ELAPSED_TO_BE_OUTDATED

  BUNDLE_AUDIT_CMD = 'bundle exec bundle-audit check --update'
  BUNDLE_AUDIT_CMD_JSON = 'bundle exec bundle-audit check --update --quiet --format json'

  YARN_AUDIT_CMD = 'yarn audit'
  YARN_AUDIT_CMD_JSON = 'yarn audit --json'

  FIELDS = %i[
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

  REPORT_FIELDS = %i[name version latest_version latest_version_date groups vulnerabilities risk_type risk_explanation]
  VULNERABLE_FIELDS = %i[name version latest_version groups vulnerabilities]
  OUTDATED_FIELDS = %i[name version latest_version latest_version_date groups]

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
