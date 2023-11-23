require_relative '../models/package'
require_relative 'gem_meta_data'
require_relative 'vulnerability_finder'

require 'bundler'

module Package
  module Audit
    module Ruby
      class BundlerSpecs
        def self.all(dir)
          Bundler.with_unbundled_env do
            ENV['BUNDLE_GEMFILE'] = "#{dir}/Gemfile"
            Bundler.ui.silence { Bundler.definition.resolve }
          end
        end

        def self.gemfile(dir)
          current_dependencies = Bundler.with_unbundled_env do
            ENV['BUNDLE_GEMFILE'] = "#{dir}/Gemfile"
            Bundler.ui.level = 'error'
            Bundler.reset!
            Bundler.ui.silence do
              Bundler.load.dependencies.to_h { |dep| [dep.name, dep] }
            end
          end

          gemfile_specs, = all(dir).partition do |spec|
            current_dependencies.key? spec.name
          end
          gemfile_specs
        end
      end
    end
  end
end
