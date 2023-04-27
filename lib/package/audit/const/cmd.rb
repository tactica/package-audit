module Package
  module Audit
    module Const
      module Cmd
        BUNDLE_AUDIT = 'bundle exec bundle-audit check --update'
        BUNDLE_AUDIT_JSON = 'bundle exec bundle-audit check --update --quiet --format json'

        NPM_AUDIT = 'npm audit'
        NPM_AUDIT_JSON = 'npm audit --json'

        YARN_AUDIT = 'yarn audit'
        YARN_AUDIT_JSON = 'yarn audit --json'
      end
    end
  end
end
