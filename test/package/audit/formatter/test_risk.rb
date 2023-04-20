require_relative '../../../../lib/package/audit/enum/risk_type'
require_relative '../../../../lib/package/audit/formatter/risk'
require_relative '../../../../lib/package/audit/util/bash_color'

require 'test_helper'

module Package
  module Audit
    module Formatter
      class TestRisk < Minitest::Test
        def test_that_high_risk_is_shown_in_proper_color
          risk = Enum::RiskType::HIGH
          format = Risk.new(risk).format
          assert_equal Util::BashColor.red(risk), format
        end

        def test_that_medium_risk_is_shown_in_proper_color
          risk = Enum::RiskType::MEDIUM
          format = Risk.new(risk).format
          assert_equal Util::BashColor.orange(risk), format
        end

        def test_that_low_risk_is_shown_in_proper_color
          risk = Enum::RiskType::LOW
          format = Risk.new(risk).format
          assert_equal Util::BashColor.yellow(risk), format
        end

        def test_that_none_risk_has_no_special_color
          risk = Enum::RiskType::NONE
          format = Risk.new(risk).format
          assert_equal risk, format
        end

        def test_that_undefined_risk_has_no_special_color
          risk = 'example'
          format = Risk.new(risk).format
          assert_equal risk, format
        end
      end
    end
  end
end
