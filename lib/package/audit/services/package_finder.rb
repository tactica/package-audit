require_relative '../const/cmd'
require_relative '../const/file'
require_relative '../const/yaml'
require_relative '../enum/technology'
require_relative '../npm/node_collection'
require_relative '../ruby/gem_collection'
require_relative 'package_filter'

require 'yaml'

module Package
  module Audit
    class PackageFinder
      def initialize(config, dir, report, groups)
        @config = config
        @dir = dir
        @report = report
        @groups = groups
      end

      def run(technology)
        all_pkgs = find_by_technology(technology)
        ignored_by_group_pkgs = filter_pkgs_based_on_group(all_pkgs)
        active_pkgs = all_pkgs - ignored_by_group_pkgs
        ignored_by_config_pkgs = filter_pkgs_based_on_config(active_pkgs)
        [active_pkgs, ignored_by_config_pkgs]
      end

      private

      def find_by_technology(technology)
        case technology
        when Enum::Technology::RUBY
          find_ruby
        when Enum::Technology::NODE
          find_node
        else
          []
        end
      end

      def find_node
        Npm::NodeCollection.new(@dir, @report).fetch
      end

      def find_ruby
        Ruby::GemCollection.new(@dir, @report).fetch
      end

      def filter_pkgs_based_on_config(pkgs)
        package_filter = PackageFilter.new(@report, @config)
        ignored_pkgs = []

        pkgs.each do |pkg|
          ignored_pkgs << pkg if package_filter.ignored?(pkg)
        end
        ignored_pkgs
      end

      def filter_pkgs_based_on_group(pkgs)
        ignored_pkgs = []

        unless @groups.nil?
          pkgs.each do |pkg|
            ignored_pkgs << pkg unless (pkg.groups & (@groups | [Enum::Group::DEFAULT])).any?
          end
        end

        ignored_pkgs
      end
    end
  end
end
