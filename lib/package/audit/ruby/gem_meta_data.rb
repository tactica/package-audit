require_relative '../models/package'

module Package
  module Audit
    module Ruby
      class GemMetaData
        def initialize(pkgs)
          @pkgs = pkgs
          @gem_hash = {}
        end

        def fetch
          find_rubygems_metadata
          assign_groups
          @gem_hash.values
        end

        private

        def find_rubygems_metadata # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
          fetcher = Gem::SpecFetcher.fetcher

          @pkgs.each do |pkg|
            gem_dependency = Gem::Dependency.new pkg.name, ">= #{pkg.version}"
            local_version_date = Time.new(0)
            latest_version_date = Time.new(0)
            local_version = Gem::Version.new(pkg.version)
            latest_version = Gem::Version.new('0.0.0.0')

            remote_dependencies, = fetcher.spec_for_dependency gem_dependency

            next unless remote_dependencies.any?

            remote_dependencies.each do |remote_spec, _|
              latest_version = remote_spec.version if latest_version < remote_spec.version
              latest_version_date = remote_spec.date if latest_version_date < remote_spec.date
              local_version_date = remote_spec.date if local_version == remote_spec.version
            end

            @gem_hash[pkg.name] = pkg
            pkg.update latest_version: latest_version.to_s,
                       version_date: local_version_date.strftime('%Y-%m-%d'),
                       latest_version_date: latest_version_date.strftime('%Y-%m-%d')
          end
        end

        def assign_groups # rubocop:disable Metrics/AbcSize
          definition = Bundler.definition
          groups = definition.groups.uniq.sort
          groups.each do |group|
            specs = definition.specs_for([group])
            specs.each do |spec|
              @gem_hash[spec.name].update(groups: @gem_hash[spec.name].groups | [group]) if @gem_hash.key? spec.name
            end
          end
        end
      end
    end
  end
end
