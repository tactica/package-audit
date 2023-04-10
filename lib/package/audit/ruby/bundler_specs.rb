require 'bundler'

module Package
  module Audit
    module Ruby
      class BundlerSpecs
        # include all gems within Gemfile and all of their dependencies, without bundler
        def self.current_specs
          Bundler::LockfileParser.new(File.read("#{Dir.pwd}/Gemfile.lock")).specs
        end

        # include only gems that are located within Gemfile
        def self.gemfile
          current_dependencies = Bundler::LockfileParser.new(File.read("#{Dir.pwd}/Gemfile.lock")).dependencies
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
