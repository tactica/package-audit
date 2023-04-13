require 'bundler'

module Package
  module Audit
    module Ruby
      class BundlerSpecs
        # include all gems within Gemfile and all of their dependencies, without bundler
        def self.current_specs(gemfile_lock_path)
          Bundler::LockfileParser.new(File.read(gemfile_lock_path)).specs
        end

        # include only gems that are located within Gemfile
        def self.gemfile(gemfile_lock_path)
          current_dependencies = Bundler::LockfileParser.new(File.read(gemfile_lock_path)).dependencies
          gemfile_specs, = current_specs(gemfile_lock_path).partition do |spec|
            current_dependencies.key? spec.name
          end
          gemfile_specs
        end

        # include only the dependencies of gems within Gemfile (without the gems themselves)
        def self.gemfile_dependencies(gemfile_lock_path)
          current_dependencies = Bundler::LockfileParser.new(File.read(gemfile_lock_path)).dependencies
          _, dependency_specs = current_specs(gemfile_lock_path).partition do |spec|
            current_dependencies.key? spec.name
          end
          dependency_specs
        end
      end
    end
  end
end
