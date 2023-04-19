require_relative './version'
require_relative './ruby/bundler_specs'
require_relative './dependency_printer'

require 'json'
require 'thor'

module Package
  module Audit
    class CLI < ::Thor
      default_task :find
      map '--version' => :version

      desc 'report [DIR]', 'Produce a report of outdated, deprecated or vulnerable dependencies.'
      method_option :csv, type: :boolean, default: false, desc: 'Output using comma separated values (CSV)'
      method_option :'exclude-headers', type: :boolean, default: false, desc: 'Hide headers if when using CSV'
      def report(dir = Dir.pwd)
        vulnerable_gems = Ruby::BundlerSpecs.vulnerable("#{dir}/Gemfile.lock")
        outdated_gems = Ruby::BundlerSpecs.gemfile("#{dir}/Gemfile.lock")
        gems = (outdated_gems + vulnerable_gems).sort_by(&:name).uniq { |gem| gem.name + gem.version }
        DependencyPrinter.new(gems, options).print
      end

      desc 'outdated [DIR]', 'Check the Gemfile.lock for outdated gems'
      method_option :'only-explicit', type: :boolean, default: false,
                                      desc: 'Only include gem explicitly defined within Gemfile'
      method_option :csv, type: :boolean, default: false, desc: 'Output using comma separated values (CSV)'
      method_option :'exclude-headers', type: :boolean, default: false, desc: 'Hide headers if when using CSV'
      def outdated(dir = Dir.pwd)
        gems = if options[:'only-explicit']
                 Ruby::BundlerSpecs.gemfile("#{dir}/Gemfile.lock")
               else
                 Ruby::BundlerSpecs.all("#{dir}/Gemfile.lock")
               end

        DependencyPrinter.new(gems, options).print(%i[name version latest_version latest_version_date])

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
        puts BashColor.red msg
        exit 1
      end

      def exit_with_success(msg)
        puts BashColor.green msg
        exit 0
      end
    end
  end
end
