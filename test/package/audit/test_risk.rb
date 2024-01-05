require 'test_helper'

require_relative '../../../lib/package/audit/models/risk'
require_relative '../../../lib/package/audit/enum/risk_type'

module Package
  module Audit
    class TestRisk < Minitest::Test
      def test_that_there_are_only_specific
        assert_equal %i[NONE LOW MEDIUM HIGH].sort, Enum::RiskType.constants.sort
      end

      def test_the_overloaded_comparison_operator_works_correctly # rubocop:disable Metrics/AbcSize
        assert_equal Risk.new(Enum::RiskType::NONE), Risk.new(Enum::RiskType::NONE)
        assert_equal Risk.new(Enum::RiskType::LOW), Risk.new(Enum::RiskType::LOW)
        assert_equal Risk.new(Enum::RiskType::MEDIUM), Risk.new(Enum::RiskType::MEDIUM)
        assert_equal Risk.new(Enum::RiskType::HIGH), Risk.new(Enum::RiskType::HIGH)

        assert_operator Risk.new(Enum::RiskType::HIGH), :>, Risk.new(Enum::RiskType::MEDIUM)
        assert_operator Risk.new(Enum::RiskType::HIGH), :>, Risk.new(Enum::RiskType::LOW)
        assert_operator Risk.new(Enum::RiskType::HIGH), :>, Risk.new(Enum::RiskType::NONE)

        assert_operator Risk.new(Enum::RiskType::MEDIUM), :>, Risk.new(Enum::RiskType::LOW)
        assert_operator Risk.new(Enum::RiskType::MEDIUM), :>, Risk.new(Enum::RiskType::NONE)

        assert_operator Risk.new(Enum::RiskType::LOW), :>, Risk.new(Enum::RiskType::NONE)
      end
    end
  end
end
