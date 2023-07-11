require_relative '../const/cmd'
require_relative '../const/file'
require_relative '../enum/option'
require_relative '../enum/report'
require_relative '../technology/detector'
require_relative '../technology/validator'
require_relative '../util/summary_printer'
require_relative 'package_finder'
require_relative 'package_printer'

require 'yaml'

module Package
  module Audit
    class CommandParser
      def initialize(dir, options, report)
        @dir = dir
        @options = options
        @report = report
        @config = parse_config_file
        @technologies = parse_technologies
      end

      def run
        cumulative_pkgs = []

        @technologies.each do |technology|
          all_pkgs, ignored_pkgs = PackageFinder.new(@config, @dir, @report).run(technology)
          ignored_pkgs = [] if @options[Enum::Option::INCLUDE_IGNORED]
          cumulative_pkgs << all_pkgs
          print_results(technology, (all_pkgs || []) - (ignored_pkgs || []), ignored_pkgs || [])
        end

        cumulative_pkgs.any?
      end

      private

      def print_results(technology, pkgs, ignored_pkgs)
        PackagePrinter.new(@options, pkgs).print(report_fields)
        print_summary(technology, pkgs, ignored_pkgs) unless @options[Enum::Option::CSV]
        print_disclaimer(technology) unless @options[Enum::Option::CSV] || pkgs.empty?
      end

      def print_summary(technology, pkgs, ignored_pkgs)
        if @report == Enum::Report::ALL
          Util::SummaryPrinter.statistics(technology, @report, pkgs, ignored_pkgs)
        else
          Util::SummaryPrinter.total(technology, @report, pkgs, ignored_pkgs)
        end
      end

      def print_disclaimer(technology)
        case @report
        when Enum::Report::DEPRECATED
          Util::SummaryPrinter.deprecated
        when Enum::Report::ALL, Enum::Report::VULNERABLE
          Util::SummaryPrinter.vulnerable(technology, learn_more_command(technology))
        end
      end

      def learn_more_command(technology)
        case technology
        when Enum::Technology::RUBY
          Const::Cmd::BUNDLE_AUDIT
        when Enum::Technology::NODE
          Const::Cmd::YARN_AUDIT
        else
          raise ArgumentError, "Unexpected technology \"#{technology}\" found in #{__method__}"
        end
      end

      def report_fields
        case @report
        when Enum::Report::DEPRECATED
          Const::Fields::DEPRECATED
        when Enum::Report::OUTDATED
          Const::Fields::OUTDATED
        when Enum::Report::VULNERABLE
          Const::Fields::VULNERABLE
        else
          Const::Fields::ALL
        end
      end

      def parse_config_file
        if @options[Enum::Option::CONFIG].nil?
          YAML.load_file("#{@dir}/#{Const::File::CONFIG}") if File.exist? "#{@dir}/#{Const::File::CONFIG}"
        elsif File.exist? @options[Enum::Option::CONFIG]
          YAML.load_file(@options[Enum::Option::CONFIG])
        else
          raise ArgumentError, "Configuration file not found: #{@options[Enum::Option::CONFIG]}"
        end
      end

      def parse_technologies
        technology_validator = Technology::Validator.new(@dir)
        @options[Enum::Option::TECHNOLOGY]&.each { |technology| technology_validator.validate! technology }
        @options[Enum::Option::TECHNOLOGY] || Technology::Detector.new(@dir).detect
      end
    end
  end
end
