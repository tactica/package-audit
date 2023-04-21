require_relative './version'
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

      desc 'report', 'Produce a report of outdated, deprecated or vulnerable dependencies.'
      method_option :csv, type: :boolean, default: false, desc: 'Output using comma separated values (CSV)'
      method_option :'exclude-headers', type: :boolean, default: false, desc: 'Hide headers if when using CSV'

      def report
        within_rescue_block do
          gems = Ruby::GemCollection.all
          DependencyPrinter.new(gems, options).print

          if gems.any?
            puts Util::BashColor.cyan("\nFound a total of #{gems.length} gems.") unless options[:csv]
            exit 1
          else
            exit_with_success 'There are no deprecated, outdated or vulnerable gems!'
          end
        end
      end

      desc 'deprecated', 'Check the Gemfile.lock for deprecated gems'
      method_option :'only-explicit', type: :boolean, default: false,
                                      desc: 'Only include gems explicitly defined within Gemfile'
      method_option :csv, type: :boolean, default: false, desc: 'Output using comma separated values (CSV)'
      method_option :'exclude-headers', type: :boolean, default: false, desc: 'Hide headers if when using CSV'

      def deprecated
        within_rescue_block do
          gems = Ruby::GemCollection.deprecated
          DependencyPrinter.new(gems, options).print

          if gems.any?
            print_total(gems.length) unless options[:csv]
            exit 1
          else
            exit_with_success 'No potential deprecated have been found!'
          end
        end
      end

      desc 'outdated', 'Check the Gemfile.lock for outdated gems'
      method_option :'only-explicit', type: :boolean, default: false,
                                      desc: 'Only include gems explicitly defined within Gemfile'
      method_option :csv, type: :boolean, default: false, desc: 'Output using comma separated values (CSV)'
      method_option :'exclude-headers', type: :boolean, default: false, desc: 'Hide headers if when using CSV'

      def outdated
        within_rescue_block do
          gems = Ruby::GemCollection.outdated
          DependencyPrinter.new(gems, options).print

          if gems.any?
            print_total(gems.length) unless options[:csv]
            exit 1
          else
            exit_with_success 'All gems are at latest versions!'
          end
        end
      end

      desc 'vulnerable', 'Check the Gemfile.lock for vulnerable gems'
      method_option :csv, type: :boolean, default: false, desc: 'Output using comma separated values (CSV)'
      method_option :'exclude-headers', type: :boolean, default: false, desc: 'Hide headers if when using CSV'

      def vulnerable
        within_rescue_block do
          gems = Ruby::GemCollection.vulnerable
          DependencyPrinter.new(gems, options).print(%i[name version latest_version groups vulnerabilities])

          if gems.any?
            print_total(gems.length) unless options[:csv]
            print_vulnerability_info unless options[:csv]
            exit 1
          else
            exit_with_success 'No vulnerabilities found!'
          end
        end
      end

      desc 'version', 'Print the package-audit version'

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

      def print_total(num)
        puts Util::BashColor.cyan("\nFound a total of #{num} gems.") unless options[:csv]
      end

      def print_vulnerability_info
        printf("\n%<info>s\n%<cmd>s\n",
               info: 'To get more information about the vulnerabilities run:',
               cmd: Util::BashColor.magenta(' > bundle-audit check --update'))
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
