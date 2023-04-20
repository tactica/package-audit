require_relative './bundler_specs'
require_relative './../enum/risk_type'

module Package
  module Audit
    module Ruby
      class GemCollection
        def initialize(dir, options)
          @dir = dir
          @options = options
        end

        def all
          specs = BundlerSpecs.gemfile("#{@dir}/Gemfile.lock")
          gemfile_gems = specs.map { |spec| Dependency.new spec.name, spec.version }
          vulnerable_gems = VulnerabilityFinder.gems(@dir)
          GemMetaData.new(gemfile_gems + vulnerable_gems).find.sort_by(&:name).uniq { |gem| gem.name + gem.version }
        end

        def deprecated
          specs = BundlerSpecs.gemfile("#{@dir}/Gemfile.lock")
          gems = specs.map { |spec| Dependency.new spec.name, spec.version }

          GemMetaData.new(gems).find.filter do |gem|
            gem.risk.explanation == Enum::RiskExplanation::POTENTIAL_DEPRECATION
          end
        end

        def outdated
          specs = if @options[:'only-explicit']
                    BundlerSpecs.gemfile("#{@dir}/Gemfile.lock")
                  else
                    BundlerSpecs.all("#{@dir}/Gemfile.lock")
                  end

          gems = specs.map { |spec| Dependency.new spec.name, spec.version }

          GemMetaData.new(gems).find.filter do |gem|
            gem.version < gem.latest_version
          end
        end

        def vulnerable
          gems = VulnerabilityFinder.gems(@dir)

          gems = GemMetaData.new(gems).find.filter do |gem|
            gem.risk.explanation == Enum::RiskExplanation::VULNERABILITY
          end

          gems.uniq { |gem| gem.name + gem.version }
        end
      end
    end
  end
end
