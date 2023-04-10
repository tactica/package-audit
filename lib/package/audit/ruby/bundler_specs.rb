require 'bundler'

module Package
  module Audit
    module Ruby
      class BundlerSpecs
        # return all specs
        def self.all
          Gem::Specification.latest_specs(true)
        end

        # include all gems within Gemfile and all of their dependencies, with bundler
        def self.current_specs
          Bundler::Definition.build(Pathname('Gemfile'), nil, nil).specs.map(&:to_spec)
        end

        # include only gems that are located within Gemfile
        def self.gemfile
          current_dependencies = Bundler.ui.silence do
            Bundler.load.dependencies.to_h { |dep| [dep.name, dep] }
          end
          gemfile_specs, = current_specs.partition do |spec|
            current_dependencies.key? spec.name
          end
          gemfile_specs
        end

        # include only the dependencies of gems within Gemfile (without the gems themselves)
        def self.gemfile_dependencies
          current_dependencies = Bundler.ui.silence do
            Bundler.load.dependencies.to_h { |dep| [dep.name, dep] }
          end
          _, dependency_specs = current_specs.partition do |spec|
            current_dependencies.key? spec.name
          end
          dependency_specs
        end
      end
    end
  end
end
