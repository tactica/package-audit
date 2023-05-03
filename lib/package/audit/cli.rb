require_relative './const/time'
require_relative './version'
require_relative './util/summary_printer'
require_relative './ruby/bundler_specs'
require_relative './printer'
require_relative './ruby/gem_collection'
require_relative './npm/node_collection'
require_relative './command_service'

require 'json'
require 'thor'

module Package
  module Audit
    class CLI < Thor
      default_task :report

      map '--version' => :version

      desc 'report', 'Show a report of potentially deprecated, outdated or vulnerable packages'
      method_option :csv, type: :boolean, default: false, desc: 'Output using comma separated values (CSV)'
      method_option :'exclude-headers', type: :boolean, default: false, desc: 'Hide headers if when using CSV'

      def report
        within_rescue_block do
          exit CommandService.new(Dir.pwd, options).all
        end
      end

      desc 'deprecated',
           "Show packages with no updates by author for at least #{Const::Time::YEARS_ELAPSED_TO_BE_OUTDATED} years"
      method_option :csv, type: :boolean, default: false, desc: 'Output using comma separated values (CSV)'
      method_option :'exclude-headers', type: :boolean, default: false, desc: 'Hide headers if when using CSV'

      def deprecated
        within_rescue_block do
          exit CommandService.new(Dir.pwd, options).deprecated
        end
      end

      desc 'outdated', 'Show packages that are out of date'
      method_option :csv, type: :boolean, default: false, desc: 'Output using comma separated values (CSV)'
      method_option :'exclude-headers', type: :boolean, default: false, desc: 'Hide headers if when using CSV'

      def outdated
        within_rescue_block do
          exit CommandService.new(Dir.pwd, options).outdated
        end
      end

      desc 'vulnerable', 'Show packages and their dependencies that have security vulnerabilities'
      method_option :csv, type: :boolean, default: false, desc: 'Output using comma separated values (CSV)'
      method_option :'exclude-headers', type: :boolean, default: false, desc: 'Hide headers if when using CSV'

      def vulnerable
        within_rescue_block do
          exit CommandService.new(Dir.pwd, options).vulnerable
        end
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
