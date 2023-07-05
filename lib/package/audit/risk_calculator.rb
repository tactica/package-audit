require_relative 'const/time'

module Package
  module Audit
    class RiskCalculator
      def initialize(pkg)
        @pkg = pkg
      end

      def find
        risks = assess_vulnerability_risks + assess_deprecation_risks + assess_version_risks

        unless production_dependency?
          risks.each_with_index do |risk, index|
            risks[index] =
              [risk, Risk.new(Enum::RiskType::MEDIUM, risk.explanation)].min || Risk.new(Enum::RiskType::NONE)
          end
        end
        risks
      end

      private

      def assess_vulnerability_risks # rubocop:disable Metrics/MethodLength
        risks = []

        if (@pkg.vulnerabilities & [
          Enum::VulnerabilityType::UNKNOWN,
          Enum::VulnerabilityType::CRITICAL,
          Enum::VulnerabilityType::HIGH
        ]).any?
          risks << Risk.new(Enum::RiskType::HIGH, Enum::RiskExplanation::VULNERABILITY)
        end
        if (@pkg.vulnerabilities & [
          Enum::VulnerabilityType::MEDIUM,
          Enum::VulnerabilityType::MODERATE
        ]).any?
          risks << Risk.new(Enum::RiskType::MEDIUM, Enum::RiskExplanation::VULNERABILITY)
        end
        if @pkg.vulnerabilities.include? Enum::VulnerabilityType::LOW
          risks << Risk.new(Enum::RiskType::LOW, Enum::RiskExplanation::VULNERABILITY)
        end
        risks
      end

      def assess_version_risks # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
        risks = []

        return risks if @pkg.latest_version.nil?

        version_parts = @pkg.version.split('.').map(&:to_i)
        latest_version_parts = @pkg.latest_version.split('.').map(&:to_i)

        if (version_parts.first || 0) < (latest_version_parts.first || 0)
          risks << Risk.new(Enum::RiskType::MEDIUM, Enum::RiskExplanation::OUTDATED_BY_MAJOR_VERSION)
        end
        if (version_parts.first || 0) == (latest_version_parts.first || 0) &&
           (version_parts[1..] <=> latest_version_parts[1..]) == -1
          risks << Risk.new(Enum::RiskType::LOW, Enum::RiskExplanation::OUTDATED)
        end
        risks
      end

      def assess_deprecation_risks
        risks = []
        seconds_since_date = (Time.now - Time.parse(@pkg.latest_version_date)).to_i

        if seconds_since_date >= Const::Time::SECONDS_ELAPSED_TO_BE_OUTDATED
          risks << Risk.new(Enum::RiskType::MEDIUM, Enum::RiskExplanation::POTENTIAL_DEPRECATION)
        end
        risks
      end

      def production_dependency?
        @pkg.groups.none? || (@pkg.groups & [Enum::Environment::DEFAULT,
                                             Enum::Environment::PRODUCTION]).any?
      end
    end
  end
end
