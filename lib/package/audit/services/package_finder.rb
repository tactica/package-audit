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
      def initialize(config, dir, report)
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

      def find_node
        Npm::NodeCollection.new(@dir, @report).fetch
      end

      def find_ruby
        Ruby::GemCollection.new(@dir, @report).fetch
      end

      def filter_pkgs_based_on_config(pkgs)
        package_filter = PackageFilter.new(@config)
        ignored_pkgs = []

        pkgs.each do |pkg|
          ignored_pkgs << pkg if package_filter.ignored?(pkg)
        end
        ignored_pkgs
      end
    end
  end
end
