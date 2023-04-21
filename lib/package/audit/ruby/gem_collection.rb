require_relative './bundler_specs'
require_relative './../enum/risk_type'

module Package
  module Audit
    module Ruby
      class GemCollection
        def initialize(options)
          @options = options
        end

        def all
          specs = BundlerSpecs.gemfile
          dependencies = specs.map { |spec| Dependency.new(spec.name, spec.version) }
          vulnerable_deps = VulnerabilityFinder.run
          GemMetaData.new(dependencies + vulnerable_deps).fetch.sort_by(&:name).uniq(&:name)
        end

        def deprecated
          specs = BundlerSpecs.gemfile
          dependencies = specs.map { |spec| Dependency.new(spec.name, spec.version) }

          GemMetaData.new(dependencies).fetch.filter do |dep|
            dep.risk.explanation == Enum::RiskExplanation::POTENTIAL_DEPRECATION
          end.sort_by(&:name).uniq(&:name)
        end

        def outdated
          specs = @options[:'only-explicit'] ? BundlerSpecs.gemfile : BundlerSpecs.all
          dependencies = specs.map { |spec| Dependency.new(spec.name, spec.version) }

          GemMetaData.new(dependencies).fetch.filter do |dep|
            dep.version < dep.latest_version
          end.sort_by(&:name).uniq(&:name)
        end

        def vulnerable
          dependencies = VulnerabilityFinder.run

          GemMetaData.new(dependencies).fetch.filter do |dep|
            dep.risk.explanation == Enum::RiskExplanation::VULNERABILITY
          end.sort_by(&:name).uniq(&:name)
        end
      end
    end
  end
end
