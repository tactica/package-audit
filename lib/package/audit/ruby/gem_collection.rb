require_relative './bundler_specs'
require_relative './../enum/risk_type'

module Package
  module Audit
    module Ruby
      class GemCollection
        def self.all
          specs = BundlerSpecs.gemfile
          pkgs = specs.map { |spec| Package.new(spec.name, spec.version) }
          vulnerable_pkgs = VulnerabilityFinder.new.run
          GemMetaData.new(pkgs + vulnerable_pkgs).fetch.filter(&:risk?).sort_by(&:full_name).uniq(&:full_name)
        end

        def self.deprecated
          specs = BundlerSpecs.gemfile
          pkgs = specs.map { |spec| Package.new(spec.name, spec.version) }

          GemMetaData.new(pkgs).fetch.filter do |pkg|
            pkg.risk.explanation == Enum::RiskExplanation::POTENTIAL_DEPRECATION
          end.sort_by(&:full_name).uniq(&:full_name)
        end

        def self.outdated(include_implicit: false)
          specs = include_implicit ? BundlerSpecs.all : BundlerSpecs.gemfile
          pkgs = specs.map { |spec| Package.new(spec.name, spec.version) }

          GemMetaData.new(pkgs).fetch.filter do |pkg|
            ([
              Enum::RiskExplanation::OUTDATED,
              Enum::RiskExplanation::OUTDATED_BY_MAJOR_VERSION
            ] & [pkg.risk.explanation]).any?
          end.sort_by(&:full_name).uniq(&:full_name)
        end

        def self.vulnerable
          pkgs = VulnerabilityFinder.new.run

          GemMetaData.new(pkgs).fetch.filter do |pkg|
            pkg.risk.explanation == Enum::RiskExplanation::VULNERABILITY
          end.sort_by(&:full_name).uniq(&:full_name)
        end
      end
    end
  end
end
