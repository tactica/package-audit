require_relative '../const'
require_relative './base'
require_relative '../util/bash_color'

require 'time'

module Package
  module Audit
    module Formatter
      class VersionDate < Formatter::Base
        def initialize(date)
          super()
          @date = date
        end

        def format
          seconds_since_date = (Time.now - Time.parse(@date)).to_i

          if seconds_since_date >= Const::SECONDS_ELAPSED_TO_BE_OUTDATED
            Util::BashColor.yellow(@date)
          else
            @date
          end
        end
      end
    end
  end
end
