require_relative './const'
require_relative './version'
require_relative './util/summary_printer'
require_relative './ruby/bundler_specs'
require_relative './dependency_printer'
require_relative './ruby/gem_collection'

require 'json'
require 'thor'

module Package
  module Audit
    class CLI < Thor
      default_task :report

      map '--version' => :version

      desc 'report', 'Show a report of potentially deprecated, outdated or vulnerable gems'
      method_option :csv, type: :boolean, default: false, desc: 'Output using comma separated values (CSV)'
      method_option :'exclude-headers', type: :boolean, default: false, desc: 'Hide headers if when using CSV'

      def report
        within_rescue_block do
          gems = Ruby::GemCollection.all
          DependencyPrinter.new(gems, options).print

          if gems.any?
            Util::SummaryPrinter.total(gems.length) unless options[:csv]
            Util::SummaryPrinter.report unless options[:csv]
            exit 1
          else
            exit_with_success 'There are no deprecated, outdated or vulnerable gems!'
          end
        end
      end

      desc 'deprecated', "Show gems with no updates by author for at least #{Const::YEARS_ELAPSED_TO_BE_OUTDATED} years"
      method_option :csv, type: :boolean, default: false, desc: 'Output using comma separated values (CSV)'
      method_option :'exclude-headers', type: :boolean, default: false, desc: 'Hide headers if when using CSV'

      def deprecated
        within_rescue_block do
          gems = Ruby::GemCollection.deprecated
          DependencyPrinter.new(gems, options).print(%i[name version latest_version latest_version_date groups])

          if gems.any?
            Util::SummaryPrinter.total(gems.length) unless options[:csv]
            Util::SummaryPrinter.deprecated unless options[:csv]
            exit 1
          else
            exit_with_success 'No potential deprecated have been found!'
          end
        end
      end

      desc 'outdated', 'Show gems, and optionally their dependencies, that are out of date'
      method_option :'include-implicit', type: :boolean, default: false,
                                         desc: 'Only both gems specified in Gemfile and their dependencies'
      method_option :csv, type: :boolean, default: false, desc: 'Output using comma separated values (CSV)'
      method_option :'exclude-headers', type: :boolean, default: false, desc: 'Hide headers if when using CSV'

      def outdated # rubocop:disable Metrics/AbcSize
        within_rescue_block do
          gems = Ruby::GemCollection.outdated(include_implicit: options[:'include-implicit'])
          DependencyPrinter.new(gems, options).print(%i[name version latest_version latest_version_date groups])

          if gems.any?
            Util::SummaryPrinter.total(gems.length) unless options[:csv]
            Util::SummaryPrinter.outdated unless options[:'include-implicit'] || options[:csv]
            exit 1
          else
            exit_with_success 'All gems are at latest versions!'
          end
        end
      end

      desc 'vulnerable', 'Show gems and their dependencies that have security vulnerabilities'
      method_option :csv, type: :boolean, default: false, desc: 'Output using comma separated values (CSV)'
      method_option :'exclude-headers', type: :boolean, default: false, desc: 'Hide headers if when using CSV'

      def vulnerable
        within_rescue_block do
          gems = Ruby::GemCollection.vulnerable
          DependencyPrinter.new(gems, options).print(%i[name version latest_version groups vulnerabilities])

          if gems.any?
            Util::SummaryPrinter.total(gems.length) unless options[:csv]
            Util::SummaryPrinter.vulnerable unless options[:csv]
            exit 1
          else
            exit_with_success 'No vulnerabilities found!'
          end
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
        raise "Gemfile was not found in #{Dir.pwd}/Gemfile" unless File.exist?("#{Dir.pwd}/Gemfile")
        raise "Gemfile.lock was not found in #{Dir.pwd}/Gemfile.lock" unless File.exist?("#{Dir.pwd}/Gemfile.lock")

        yield
      rescue StandardError => e
        exit_with_error "#{e.class}: #{e.message}"
      end

      def exit_with_error(msg)
        puts Util::BashColor.red msg
        exit 1
      end

      def exit_with_success(msg)
        puts Util::BashColor.green msg
        exit 0
      end
    end
  end
end
