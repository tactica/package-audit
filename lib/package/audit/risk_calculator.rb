module Package
  module Audit
    class RiskCalculator
      SECONDS_PER_YEAR = 31_536_000 # assuming 24-hour days and 365-day years

      def initialize(dependency)
        @dependency = dependency
      end

      def find
        vulnerability_risk = assess_vulnerability_risk
        version_risk = assess_version_risk

        [vulnerability_risk, version_risk].max
      end

      private

      def assess_vulnerability_risk
        case @dependency.vulnerability
        when Enum::VulnerabilityType::UNKNOWN, Enum::VulnerabilityType::CRITICAL, Enum::VulnerabilityType::HIGH
          Risk.new(Enum::RiskType::HIGH, Enum::RiskExplanation::VULNERABILITY)
        when Enum::VulnerabilityType::MEDIUM
          Risk.new(Enum::RiskType::MEDIUM, Enum::RiskExplanation::VULNERABILITY)
        when Enum::VulnerabilityType::LOW
          Risk.new(Enum::RiskType::LOW, Enum::RiskExplanation::VULNERABILITY)
        else
          Risk.new(Enum::RiskType::NONE, nil)
        end
      end

      def assess_version_risk # rubocop:disable Metrics/AbcSize
        seconds_since_date = (Time.now - Time.parse(@dependency.latest_version_date)).to_i

        if @dependency.version == @dependency.latest_version && seconds_since_date >= SECONDS_PER_YEAR
          Risk.new(Enum::RiskType::MEDIUM, Enum::RiskExplanation::POTENTIAL_DEPRECATION)
        elsif (@dependency.version.split('.').first || '') < (@dependency.latest_version.split('.').first || '')
          Risk.new(Enum::RiskType::MEDIUM, Enum::RiskExplanation::OUTDATED_BY_MAJOR_VERSION)
        elsif @dependency.version < @dependency.latest_version
          Risk.new(Enum::RiskType::LOW, Enum::RiskExplanation::OUTDATED)
        else
          Risk.new(Enum::RiskType::NONE, nil)
        end
      end
    end
  end
end
