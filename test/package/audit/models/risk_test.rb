require 'test_helper'

require_relative '../../../../lib/package/audit/risk'
require_relative '../../../../lib/package/audit/enum/risk_type'

module Package
  module Audit
    class RiskTest < Minitest::Test
      def test_that_there_are_only_specific
        assert_equal %i[NONE LOW MEDIUM HIGH].sort, Enum::RiskType.constants.sort
      end

      def test_the_overloaded_comparison_operator_works_correctly # rubocop:disable Metrics/AbcSize
        assert_equal Risk.new(Enum::RiskType::NONE, nil), Risk.new(Enum::RiskType::NONE, nil)
        assert_equal Risk.new(Enum::RiskType::LOW, nil), Risk.new(Enum::RiskType::LOW, nil)
        assert_equal Risk.new(Enum::RiskType::MEDIUM, nil), Risk.new(Enum::RiskType::MEDIUM, nil)
        assert_equal Risk.new(Enum::RiskType::HIGH, nil), Risk.new(Enum::RiskType::HIGH, nil)

        assert Risk.new(Enum::RiskType::HIGH, nil) > Risk.new(Enum::RiskType::MEDIUM, nil)
        assert Risk.new(Enum::RiskType::HIGH, nil) > Risk.new(Enum::RiskType::LOW, nil)
        assert Risk.new(Enum::RiskType::HIGH, nil) > Risk.new(Enum::RiskType::NONE, nil)

        assert Risk.new(Enum::RiskType::MEDIUM, nil) > Risk.new(Enum::RiskType::LOW, nil)
        assert Risk.new(Enum::RiskType::MEDIUM, nil) > Risk.new(Enum::RiskType::NONE, nil)

        assert Risk.new(Enum::RiskType::LOW, nil) > Risk.new(Enum::RiskType::NONE, nil)
      end
    end
  end
end
