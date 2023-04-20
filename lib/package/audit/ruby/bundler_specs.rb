require_relative '../dependency'
require_relative './gem_meta_data'
require_relative './vulnerability_finder'

module Package
  module Audit
    module Ruby
      class BundlerSpecs
        def self.all(gemfile_lock_path)
          gems_from_specs Bundler::LockfileParser.new(File.read(gemfile_lock_path)).specs
        end

        def self.gemfile(gemfile_lock_path)
          current_dependencies = Bundler::LockfileParser.new(File.read(gemfile_lock_path)).dependencies
          gems, = all(gemfile_lock_path).partition do |spec|
            current_dependencies.key? spec.name
          end
          gems
        end

        private_class_method def self.gems_from_specs(specs)
          gems = specs.map { |spec| Dependency.new spec.name, spec.version }
          GemMetaData.new(gems).find.filter(&:risk?)
        end
      end
    end
  end
end
