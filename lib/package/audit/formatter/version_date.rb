require_relative './base'
require_relative '../bash_color'

module Package
  module Audit
    module Formatter
      class VersionDate < Formatter::Base
        SECONDS_PER_YEAR = 31_536_000 # assuming 24-hour days and 365-day years

        def initialize(date)
          super()
          @date = date
        end

        def format
          seconds_since_date = (Time.now - Time.parse(@date)).to_i

          if seconds_since_date >= SECONDS_PER_YEAR
            BashColor.yellow(@date)
          else
            @date
          end
        end
      end
    end
  end
end
