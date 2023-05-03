require_relative './bundler_specs'
require_relative './../enum/risk_type'
require_relative '../duplicate_package_merger'

module Package
  module Audit
    module Ruby
      class GemCollection
        def self.all
          specs = BundlerSpecs.gemfile
          pkgs = specs.map { |spec| Package.new(spec.name, spec.version) }
          vulnerable_pkgs = VulnerabilityFinder.new.run
          pkgs = GemMetaData.new(pkgs + vulnerable_pkgs).fetch.filter(&:risk?)
          DuplicatePackageMerger.new(pkgs).run
        end

        def self.deprecated
          specs = BundlerSpecs.gemfile
          pkgs = specs.map { |spec| Package.new(spec.name, spec.version) }
          pkgs = GemMetaData.new(pkgs).fetch.filter(&:deprecated?)
          DuplicatePackageMerger.new(pkgs).run
        end

        def self.outdated(include_implicit: false)
          specs = include_implicit ? BundlerSpecs.all : BundlerSpecs.gemfile
          pkgs = specs.map { |spec| Package.new(spec.name, spec.version) }
          pkgs = GemMetaData.new(pkgs).fetch.filter(&:outdated?)
          DuplicatePackageMerger.new(pkgs).run
        end

        def self.vulnerable
          pkgs = VulnerabilityFinder.new.run
          pkgs = GemMetaData.new(pkgs).fetch.filter(&:vulnerable?)
          DuplicatePackageMerger.new(pkgs).run
        end
      end
    end
  end
end
