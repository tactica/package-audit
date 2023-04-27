require_relative './yarn_lock_parser'
require_relative './npm_meta_data'
require_relative './vulnerability_finder'

module Package
  module Audit
    module Npm
      class NodeCollection
        PACKAGE_JSON = 'package.json'
        PACKAGE_LOCK = 'package-lock.json'
        YARN_LOCK = 'yarn.lock'

        def initialize(dir)
          @dir = dir
        end

        def all
          implicit_pkgs = fetch_from_lock_file
          vulnerable_pkgs = VulnerabilityFinder.new(implicit_pkgs).run
          NpmMetaData.new(vulnerable_pkgs + implicit_pkgs).fetch.filter(&:risk?).sort_by(&:full_name).uniq(&:full_name)
        end

        def deprecated
          implicit_pkgs = fetch_from_lock_file
          NpmMetaData.new(implicit_pkgs).fetch.filter do |dep|
            dep.risk.explanation == Enum::RiskExplanation::POTENTIAL_DEPRECATION
          end.sort_by(&:full_name).uniq(&:full_name)
        end

        def outdated
          implicit_pkgs = fetch_from_lock_file
          NpmMetaData.new(implicit_pkgs).fetch.filter do |dep|
            [
              Enum::RiskExplanation::OUTDATED,
             Enum::RiskExplanation::OUTDATED_BY_MAJOR_VERSION
            ].include? dep.risk.explanation
          end.sort_by(&:full_name).uniq(&:full_name)
        end

        def vulnerable
          implicit_pkgs = fetch_from_lock_file
          vulnerable_pkgs = VulnerabilityFinder.new(implicit_pkgs).run
          NpmMetaData.new(vulnerable_pkgs).fetch.filter(&:risk?).sort_by(&:full_name).uniq(&:full_name)
        end

        private

        def fetch_from_package_json
          package_json = JSON.parse(File.read("#{@dir}/#{PACKAGE_JSON}"), symbolize_names: true)
          default_deps = package_json[:dependencies] || {}
          dev_deps = package_json[:devDependencies] || {}
          [default_deps, dev_deps]
        end

        def fetch_from_lock_file
          default_deps, dev_deps = fetch_from_package_json
          if File.exist?("#{@dir}/#{YARN_LOCK}")
            YarnLockParser.new("#{@dir}/#{YARN_LOCK}").fetch(default_deps || {}, dev_deps || {})
          else
            []
          end
        end
      end
    end
  end
end
