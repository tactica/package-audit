require_relative './const'

module Package
  module Audit
    class RiskCalculator
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
        if (@dependency.vulnerabilities & [Enum::VulnerabilityType::UNKNOWN, Enum::VulnerabilityType::CRITICAL,
                                           Enum::VulnerabilityType::HIGH]).any?
          Risk.new(Enum::RiskType::HIGH, Enum::RiskExplanation::VULNERABILITY)
        elsif @dependency.vulnerabilities.include? Enum::VulnerabilityType::MEDIUM
          Risk.new(Enum::RiskType::MEDIUM, Enum::RiskExplanation::VULNERABILITY)
        elsif @dependency.vulnerabilities.include? Enum::VulnerabilityType::LOW
          Risk.new(Enum::RiskType::LOW, Enum::RiskExplanation::VULNERABILITY)
        else
          Risk.new(Enum::RiskType::NONE)
        end
      end

      def assess_version_risk # rubocop:disable Metrics/AbcSize
        seconds_since_date = (Time.now - Time.parse(@dependency.latest_version_date)).to_i

        if @dependency.version == @dependency.latest_version &&
           seconds_since_date >= Const::SECONDS_ELAPSED_TO_BE_OUTDATED
          Risk.new(Enum::RiskType::MEDIUM, Enum::RiskExplanation::POTENTIAL_DEPRECATION)
        elsif (@dependency.version.split('.').first || '') < (@dependency.latest_version.split('.').first || '')
          Risk.new(Enum::RiskType::MEDIUM, Enum::RiskExplanation::OUTDATED_BY_MAJOR_VERSION)
        elsif @dependency.version < @dependency.latest_version
          Risk.new(Enum::RiskType::LOW, Enum::RiskExplanation::OUTDATED)
        else
          Risk.new(Enum::RiskType::NONE)
        end
      end
    end
  end
end
