module Package
  module Audit
    class Risk
      include Comparable

      attr_reader :type, :explanation

      def initialize(type, explanation)
        @type = type
        @explanation = explanation
      end

      def <=>(other) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
        if @type == other.type
          0
        elsif (@type == Enum::RiskType::HIGH && [Enum::RiskType::MEDIUM, Enum::RiskType::LOW,
                                                 Enum::RiskType::NONE].include?(other.type)) ||
              (@type == Enum::RiskType::MEDIUM && [Enum::RiskType::LOW, Enum::RiskType::NONE].include?(other.type)) ||
              (@type == Enum::RiskType::LOW && [Enum::RiskType::NONE].include?(other.type))
          1
        else
          -1
        end
      end
    end
  end
end
