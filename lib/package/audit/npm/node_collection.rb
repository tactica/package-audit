require_relative '../const/file'
require_relative '../services/duplicate_package_merger'
require_relative 'npm_meta_data'
require_relative 'vulnerability_finder'
require_relative 'yarn_lock_parser'

module Package
  module Audit
    module Npm
      class NodeCollection
        def initialize(dir, report)
          @dir = dir
          @report = report
        end

        def fetch
          case @report
          when Enum::Report::DEPRECATED
            deprecated
          when Enum::Report::OUTDATED
            outdated
          when Enum::Report::VULNERABLE
            vulnerable
          else
            all
          end
        end

        def all
          implicit_pkgs = fetch_from_lock_file
          vulnerable_pkgs = VulnerabilityFinder.new(@dir, implicit_pkgs).run
          pkgs = NpmMetaData.new(vulnerable_pkgs + implicit_pkgs).fetch.filter(&:risk?)
          DuplicatePackageMerger.new(pkgs).run
        end

        def deprecated
          implicit_pkgs = fetch_from_lock_file
          pkgs = NpmMetaData.new(implicit_pkgs).fetch.filter(&:deprecated?)
          DuplicatePackageMerger.new(pkgs).run
        end

        def outdated
          implicit_pkgs = fetch_from_lock_file
          pkgs = NpmMetaData.new(implicit_pkgs).fetch.filter(&:outdated?)
          DuplicatePackageMerger.new(pkgs).run
        end

        def vulnerable
          implicit_pkgs = fetch_from_lock_file
          vulnerable_pkgs = VulnerabilityFinder.new(@dir, implicit_pkgs).run
          pkgs = NpmMetaData.new(vulnerable_pkgs).fetch
          DuplicatePackageMerger.new(pkgs).run
        end

        private

        def fetch_from_package_json
          package_json = JSON.parse(File.read("#{@dir}/#{Const::File::PACKAGE_JSON}"), symbolize_names: true)
          default_deps = package_json[:dependencies] || {}
          dev_deps = package_json[:devDependencies] || {}
          [default_deps, dev_deps]
        end

        def fetch_from_lock_file
          default_deps, dev_deps = fetch_from_package_json
          if File.exist?("#{@dir}/#{Const::File::YARN_LOCK}")
            YarnLockParser.new("#{@dir}/#{Const::File::YARN_LOCK}").fetch(default_deps || {}, dev_deps || {})
          else
            []
          end
        end
      end
    end
  end
end
