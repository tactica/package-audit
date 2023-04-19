require_relative '../dependency'

module Package
  module Audit
    module Ruby
      class GemMetaData
        def initialize(dependencies)
          @dependencies = dependencies
        end

        def find # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
          fetcher = Gem::SpecFetcher.fetcher

          @dependencies.each do |dependency|
            gem_dependency = Gem::Dependency.new dependency.name, ">= #{dependency.version}"
            local_version_date = Time.new(0)
            latest_version_date = Time.new(0)
            local_version = Gem::Version.new(dependency.version)
            latest_version = Gem::Version.new('0.0.0')

            remote_specs, = fetcher.spec_for_dependency gem_dependency

            remote_specs.each do |remote_spec, _|
              latest_version = remote_spec.version if latest_version < remote_spec.version
              latest_version_date = remote_spec.date if latest_version_date < remote_spec.date
              local_version_date = remote_spec.date if local_version == remote_spec.version
            end

            dependency.update latest_version: latest_version.to_s,
                              version_date: local_version_date.strftime('%Y-%m-%d'),
                              latest_version_date: latest_version_date.strftime('%Y-%m-%d')
          end
        end
      end
    end
  end
end
