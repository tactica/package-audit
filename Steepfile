target :lib do
  signature 'sig'

  check 'lib'

  # This file is excluded, as steep does not recognize the thor gem
  ignore 'lib/package/audit/cli.rb'

  # Standard libraries
  library 'json', 'set'
  library 'pathname', 'set'
  library 'time', 'set'
end