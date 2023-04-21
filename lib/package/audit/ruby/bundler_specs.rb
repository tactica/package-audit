require_relative '../dependency'
require_relative './gem_meta_data'
require_relative './vulnerability_finder'

module Package
  module Audit
    module Ruby
      class BundlerSpecs
        def self.all
          Bundler.ui.silence { Bundler.definition.resolve }
        end

        def self.gemfile
          current_dependencies = Bundler.ui.silence do
            Bundler.load.dependencies.to_h { |dep| [dep.name, dep] }
          end

          gemfile_specs, = all.partition do |spec|
            current_dependencies.key? spec.name
          end
          gemfile_specs
        end
      end
    end
  end
end
