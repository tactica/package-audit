require_relative '../const/cmd'
require_relative '../const/file'
require_relative '../const/yaml'
require_relative '../enum/technology'
require_relative '../ruby/gem_collection'

require 'yaml'

module Package
  module Audit
    class PackageFilter
      def initialize(config)
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
        (pkg.deprecated? && yaml&.dig(Const::YAML::DEPRECATED) != false) ||
          (pkg.outdated? && yaml&.dig(Const::YAML::OUTDATED) != false) ||
          (pkg.vulnerable? && yaml&.dig(Const::YAML::VULNERABLE) != false)
      end
    end
  end
end
