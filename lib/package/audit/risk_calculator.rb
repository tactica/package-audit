require_relative './const'

module Package
  module Audit
    class RiskCalculator
      def initialize(dependency)
        @dependency = dependency
      end

      def find
        vulnerability_risk = assess_vulnerability_risk
        deprecation_risk = assess_vulnerability_risk
        version_risk = assess_version_risk

        risk = [vulnerability_risk, deprecation_risk, version_risk].max
        risk = [risk, Risk.new(Enum::RiskType::MEDIUM, risk.explanation)].min unless risk.nil? || production_dependency?
        risk
      end

      private

      def assess_vulnerability_risk # rubocop:disable Metrics/MethodLength
        if (@dependency.vulnerabilities & [
          Enum::VulnerabilityType::UNKNOWN,
          Enum::VulnerabilityType::CRITICAL,
          Enum::VulnerabilityType::HIGH
        ]).any?
          Risk.new(Enum::RiskType::HIGH, Enum::RiskExplanation::VULNERABILITY)
        elsif @dependency.vulnerabilities.include? Enum::VulnerabilityType::MEDIUM
          Risk.new(Enum::RiskType::MEDIUM, Enum::RiskExplanation::VULNERABILITY)
        elsif @dependency.vulnerabilities.include? Enum::VulnerabilityType::LOW
          Risk.new(Enum::RiskType::LOW, Enum::RiskExplanation::VULNERABILITY)
        else
          Risk.new(Enum::RiskType::NONE)
        end
      end

      def assess_version_risk
        if (@dependency.version.split('.').first || '') < (@dependency.latest_version.split('.').first || '')
          Risk.new(Enum::RiskType::MEDIUM, Enum::RiskExplanation::OUTDATED_BY_MAJOR_VERSION)
        elsif @dependency.version < @dependency.latest_version
          Risk.new(Enum::RiskType::LOW, Enum::RiskExplanation::OUTDATED)
        else
          Risk.new(Enum::RiskType::NONE)
        end
      end

      def assess_deprecation_risk
        seconds_since_date = (Time.now - Time.parse(@dependency.latest_version_date)).to_i

        if @dependency.version == @dependency.latest_version &&
           seconds_since_date >= Const::SECONDS_ELAPSED_TO_BE_OUTDATED
          Risk.new(Enum::RiskType::MEDIUM, Enum::RiskExplanation::POTENTIAL_DEPRECATION)
        else
          Risk.new(Enum::RiskType::NONE)
        end
      end

      def production_dependency?
        @dependency.groups.none? || (@dependency.groups & [Enum::Environment::DEFAULT,
                                                           Enum::Environment::PRODUCTION]).any?
      end
    end
  end
end
