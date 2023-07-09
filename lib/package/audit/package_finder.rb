require 'yaml'

require_relative 'const/cmd'
require_relative 'const/file'
require_relative 'enum/report'
require_relative 'enum/technology'

module Package
  module Audit
    class PackageFinder
      def initialize(config, report, dir)
        @config = config
        @dir = dir
        @report = report
      end

      def run(technology)
        all_pkgs = find_by_technology(technology)
        ignored_pkgs = filter_pkgs_based_on_config(all_pkgs)
        [all_pkgs, ignored_pkgs]
      end

      private

      def find_by_technology(technology)
        case technology
        when Enum::Technology::RUBY
          find_ruby
        else
          find_node
        end
      end

      def find_ruby
        Ruby::GemCollection.new(@dir, @report).fetch
      end

      def find_node
        Npm::NodeCollection.new(@dir, @report).fetch
      end

      def filter_pkgs_based_on_config(pkgs)
        return [] if @config.nil?

        ignored_pkgs = []
        pkgs.each do |pkg|
          yaml_fragment = @config.dig('packages', pkg.technology, pkg.name)&.to_yaml
          pkg_yaml = yaml_fragment.nil? ? nil : YAML.safe_load(yaml_fragment)
          next unless pkg_yaml&.dig('version') == pkg.version

          next unless (!pkg.deprecated? || pkg_yaml['deprecated'] == false) &&
                      (!pkg.outdated? || pkg_yaml['outdated'] == false) &&
                      (!pkg.vulnerable? || pkg_yaml['vulnerable'] == false)

          ignored_pkgs << pkg
        end
        ignored_pkgs
      end
    end
  end
end
