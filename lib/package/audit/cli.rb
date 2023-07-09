require_relative 'const/time'
require_relative 'version'
require_relative 'util/summary_printer'
require_relative 'ruby/bundler_specs'
require_relative 'printer'
require_relative 'ruby/gem_collection'
require_relative 'npm/node_collection'
require_relative 'command_parser'
require_relative 'enum/report'

require 'json'
require 'thor'

module Package
  module Audit
    class CLI < Thor
      default_task :report

      class_option Enum::Option::CONFIG,
                   aliases: '-c', banner: 'FILE',
                   desc: "Path to a custom configuration file, default: #{Const::File::CONFIG})"
      class_option Enum::Option::TECHNOLOGY,
                   aliases: '-t', repeatable: true,
                   desc: 'Technology to be audited (repeat this flag for each technology)'
      class_option Enum::Option::INCLUDE_IGNORED,
                   type: :boolean, default: false,
                   desc: 'Include packages ignored by a configuration file'
      class_option Enum::Option::CSV,
                   type: :boolean, default: false,
                   desc: 'Output reports using comma separated values (CSV)'
      class_option Enum::Option::CSV_EXCLUDE_HEADERS,
                   type: :boolean, default: false,
                   desc: "Hide headers when using the --#{Enum::Option::CSV} option"

      map '-v' => :version
      map '--version' => :version

      def respond_to_missing?
        true
      end

      def method_missing(command, *args)
        invoke :report, [command], args
      end

      desc 'report [DIR]', 'Show a report of potentially deprecated, outdated or vulnerable packages'
      def report(dir = Dir.pwd)
        within_rescue_block { exit CommandParser.new(Enum::Report::ALL, dir, options).run }
      end

      desc 'deprecated [DIR]',
           "Show packages with no updates by author for at least #{Const::Time::YEARS_ELAPSED_TO_BE_OUTDATED} years"
      def deprecated(dir = Dir.pwd)
        within_rescue_block { exit CommandParser.new(Enum::Report::DEPRECATED, dir, options).run }
      end

      desc 'outdated [DIR]', 'Show packages that are out of date'
      def outdated(dir = Dir.pwd)
        within_rescue_block { exit CommandParser.new(Enum::Report::OUTDATED, dir, options).run }
      end

      desc 'vulnerable [DIR]', 'Show packages and their dependencies that have security vulnerabilities'
      def vulnerable(dir = Dir.pwd)
        within_rescue_block { exit CommandParser.new(Enum::Report::VULNERABLE, dir, options).run }
      end

      desc 'risk', 'Print information on how risk is calculated'
      def risk
        Util::SummaryPrinter.risk
      end

      desc 'version', 'Print the currently installed version of the package-audit gem'
      def version
        puts "package-audit #{VERSION}"
      end

      def self.exit_on_failure?
        true
      end

      private

      def within_rescue_block
        yield
      rescue StandardError => e
        exit_with_error "#{e.class}: #{e.message}"
      end

      def exit_with_error(msg)
        puts Util::BashColor.red msg
        exit 1
      end
    end
  end
end
