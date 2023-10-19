require_relative '../const/cmd'
require_relative '../const/file'
require_relative '../enum/option'
require_relative '../enum/report'
require_relative '../technology/detector'
require_relative '../technology/validator'
require_relative '../util/summary_printer'
require_relative '../util/loading_indicator'
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
        @loading_indicator = Util::LoadingIndicator.new('Evaluating packages and their dependencies...')
      end

      def run
        mutex = Mutex.new
        cumulative_pkgs = []
        thread_index = 0

        @loading_indicator.start
        threads = @technologies.map.with_index do |technology, technology_index|
          Thread.new do
            all_pkgs, ignored_pkgs = PackageFinder.new(@config, @dir, @report).run(technology)
            ignored_pkgs = [] if @options[Enum::Option::INCLUDE_IGNORED]
            cumulative_pkgs << all_pkgs
            sleep 0.1 while technology_index != thread_index
            mutex.synchronize do
              print "\r"
              print_results(technology, (all_pkgs || []) - (ignored_pkgs || []), ignored_pkgs || [])
              thread_index += 1
            end
          end
        end
        threads.each(&:join)
        @loading_indicator.stop
        print "WEFOIJWEFOIJEWF"

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
