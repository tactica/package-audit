require_relative 'gem_data'

module Package
  module Audit
    module Ruby
      class GemFinder
        def self.outdated(specs) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength
          gems = []
          fetcher = Gem::SpecFetcher.fetcher

          specs.each do |local_spec|
            dependency = Gem::Dependency.new local_spec.name, ">= #{local_spec.version}"
            local_spec_date = Time.new(0)
            latest_version_date = Time.new(0)
            latest_version = Gem::Version.new('0.0.0')

            remote_specs, = fetcher.spec_for_dependency dependency

            remote_specs.each do |remote_spec, _|
              latest_version = remote_spec.version if latest_version < remote_spec.version
              latest_version_date = remote_spec.date if latest_version_date < remote_spec.date
              local_spec_date = remote_spec.date if local_spec.version == remote_spec.version
            end

            next unless local_spec.version < latest_version

            gems << GemData.new(
              name: local_spec.name,
              curr_version: local_spec.version.to_s,
              latest_version: latest_version.to_s,
              curr_version_date: local_spec_date,
              latest_version_date: latest_version_date
            )
          end

          gems.sort_by(&:name)
        end
      end
    end
  end
end
