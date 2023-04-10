require 'package/audit/version'
require 'package/audit/ruby/bundler_specs'
require 'package/audit/ruby/gem_finder'
require 'package/audit/ruby/gem_printer'

require 'thor'

module Package
  module Audit
    class CLI < ::Thor
      default_task :outdated
      map '--version' => :version

      desc 'outdated [DIR]', 'Check the Gemfile.lock for outdated gems'
      method_option :'only-explicit', type: :boolean, default: false,
                                      desc: 'Only include gem explicitly defined within Gemfile'
      method_option :csv, type: :boolean, default: false, desc: 'Output using comma separated values (CSV)'
      method_option :'exclude-headers', type: :boolean, default: false, desc: 'Hide headers if when using CSV'

      def outdated(dir = Dir.pwd) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        Dir.chdir dir

        specs = if options[:'only-explicit']
                  Ruby::BundlerSpecs.gemfile
                else
                  Ruby::BundlerSpecs.current_specs
                end

        gems = Ruby::GemFinder.outdated(specs)

        puts
        if options[:csv]
          Ruby::GemPrinter.csv(gems, exclude_headers: options[:'exclude-headers'])
        else
          Ruby::GemPrinter.pretty(gems)
        end

        if gems.any?
          exit 1
        else
          exit_with_success 'Bundle up to date!'
        end
      rescue StandardError => e
        exit_with_error "#{e.class}: #{e.message}"
      end

      desc 'version', 'Print the package-audit version'
      def version
        puts "package-audit #{VERSION}"
      end

      def self.exit_on_failure?
        true
      end

      private

      def exit_with_error(msg)
        puts "\e[31m#{msg}\e[0m"
        exit 1
      end

      def exit_with_success(msg)
        puts "\e[32m#{msg}\e[0m"
        exit 0
      end
    end
  end
end
