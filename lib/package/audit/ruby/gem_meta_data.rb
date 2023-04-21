require_relative '../dependency'

module Package
  module Audit
    module Ruby
      class GemMetaData
        def initialize(dependencies)
          @dependencies = dependencies
          @gems = {}
        end

        def fetch
          find_rubygems_metadata
          assign_groups
          @gems.values
        end

        private

        def find_rubygems_metadata # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
          fetcher = Gem::SpecFetcher.fetcher

          @dependencies.each do |dep|
            gem_dependency = Gem::Dependency.new dep.name, ">= #{dep.version}"
            local_version_date = Time.new(0)
            latest_version_date = Time.new(0)
            local_version = Gem::Version.new(dep.version)
            latest_version = Gem::Version.new('0.0.0')

            remote_dependencies, = fetcher.spec_for_dependency gem_dependency

            remote_dependencies.each do |remote_spec, _|
              latest_version = remote_spec.version if latest_version < remote_spec.version
              latest_version_date = remote_spec.date if latest_version_date < remote_spec.date
              local_version_date = remote_spec.date if local_version == remote_spec.version
            end

            @gems[dep.name] = dep
            dep.update latest_version: latest_version.to_s,
                       version_date: local_version_date.strftime('%Y-%m-%d'),
                       latest_version_date: latest_version_date.strftime('%Y-%m-%d')
          end
        end

        def assign_groups
          definition = Bundler.definition
          groups = definition.groups.uniq.sort
          groups.each do |group|
            specs = definition.specs_for([group])
            specs.each do |spec|
              @gems[spec.name].update(groups: @gems[spec.name].groups | [group]) if @gems.key? spec.name
            end
          end
        end
      end
    end
  end
end
