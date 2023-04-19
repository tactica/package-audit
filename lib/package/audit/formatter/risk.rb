require_relative './base'
require_relative '../bash_color'

module Package
  module Audit
    module Formatter
      class Risk < Formatter::Base
        def initialize(risk_type)
          super()
          @risk_type = risk_type
        end

        def format
          case @risk_type
          when Enum::RiskType::HIGH
            BashColor.red(Enum::RiskType::HIGH)
          when Enum::RiskType::MEDIUM
            BashColor.orange(Enum::RiskType::MEDIUM)
          when Enum::RiskType::LOW
            BashColor.yellow(Enum::RiskType::LOW)
          else
            @risk_type.to_s
          end
        end
      end
    end
  end
end
