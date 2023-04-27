module Package
  module Audit
    module Const
      module Time
        SECONDS_PER_YEAR = 31_556_952 # length of a gregorian year (365.2425 days)
        YEARS_ELAPSED_TO_BE_OUTDATED = 2
        SECONDS_ELAPSED_TO_BE_OUTDATED = SECONDS_PER_YEAR * YEARS_ELAPSED_TO_BE_OUTDATED
      end
    end
  end
end
