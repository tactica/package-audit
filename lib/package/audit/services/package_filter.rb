require_relative '../const/cmd'
require_relative '../const/file'
require_relative '../const/yaml'
require_relative '../enum/technology'
require_relative '../ruby/gem_collection'

require 'yaml'

module Package
  module Audit
    class PackageFilter
      def initialize(report, config)
        @report = report
        @config = config
      end

      def ignored?(pkg)
        pkg_yaml = pkg_yaml_from_config(pkg)
        pkg_version_in_config?(pkg, pkg_yaml) && ignore_package?(pkg, pkg_yaml)
      end

      private

      def pkg_yaml_from_config(pkg)
        yaml_fragment = @config&.dig(Const::YAML::TECHNOLOGY, pkg.technology, pkg.name)&.to_yaml
        yaml_fragment.nil? ? nil : YAML.safe_load(yaml_fragment)
      end

      def pkg_version_in_config?(pkg, yaml)
        yaml&.dig(Const::YAML::VERSION) == pkg.version
      end

      def ignore_package?(pkg, yaml)
        case @report
        when Enum::Report::DEPRECATED
          ignore_deprecated?(pkg, yaml)
        when Enum::Report::OUTDATED
          ignore_outdated?(pkg, yaml)
        when Enum::Report::VULNERABLE
          ignore_vulnerable?(pkg, yaml)
        else
          ignore_deprecated?(pkg, yaml) && ignore_outdated?(pkg, yaml) && ignore_vulnerable?(pkg, yaml)
        end
      end

      def ignore_deprecated?(pkg, yaml)
        !pkg.deprecated? || yaml&.dig(Const::YAML::DEPRECATED) == false
      end

      def ignore_outdated?(pkg, yaml)
        !pkg.outdated? || yaml&.dig(Const::YAML::OUTDATED) == false
      end

      def ignore_vulnerable?(pkg, yaml)
        !pkg.vulnerable? || yaml&.dig(Const::YAML::VULNERABLE) == false
      end
    end
  end
end
