require_relative './const/cmd'
require_relative './const/file'

module Package
  module Audit
    class CommandService # rubocop:disable Metrics/ClassLength
      RUBY_GEM = 'ruby gem'
      NODE_MODULE = 'node module'

      def initialize(dir, options)
        @dir = dir
        @options = options
      end

      def all # rubocop:disable Metrics/AbcSize, Metrics/MethodLength, Metrics/PerceivedComplexity
        pkgs = []

        if ruby?
          gems = Ruby::GemCollection.all
          pkgs += gems
          Printer.new(gems, @options).print(Const::Fields::REPORT)

          unless @options[:csv]
            if gems.any?
              Util::SummaryPrinter.total(RUBY_GEM, gems.length)
              Util::SummaryPrinter.vulnerable(RUBY_GEM, Const::Cmd::BUNDLE_AUDIT)
            else
              print_success_message "There are no deprecated, outdated or vulnerable #{RUBY_GEM}s!"
            end
          end
        end

        if node?
          npms = Npm::NodeCollection.new(@dir).all
          pkgs += npms
          Printer.new(npms, @options).print(Const::Fields::REPORT)

          unless @options[:csv]
            if npms.any?
              Util::SummaryPrinter.total(NODE_MODULE, npms.length)
              Util::SummaryPrinter.vulnerable(NODE_MODULE, Const::Cmd::YARN_AUDIT)
            else
              print_success_message "There are no deprecated, outdated or vulnerable #{NODE_MODULE}s!"
            end
          end
        end

        pkgs.any?
      end

      def vulnerable # rubocop:disable Metrics/AbcSize, Metrics/MethodLength, Metrics/PerceivedComplexity
        pkgs = []

        if ruby?
          gems = Ruby::GemCollection.vulnerable
          pkgs += gems
          Printer.new(gems, @options).print(Const::Fields::VULNERABLE)

          unless @options[:csv]
            if gems.any?
              Util::SummaryPrinter.total(RUBY_GEM, gems.length)
              Util::SummaryPrinter.vulnerable(RUBY_GEM, Const::Cmd::BUNDLE_AUDIT)
            else
              print_success_message "There are no #{RUBY_GEM} vulnerabilities!"
            end
          end
        end

        if node?
          npms = Npm::NodeCollection.new(@dir).vulnerable
          pkgs += npms
          Printer.new(npms, @options).print(Const::Fields::VULNERABLE)

          unless @options[:csv]
            if npms.any?
              Util::SummaryPrinter.total(NODE_MODULE, npms.length)
              Util::SummaryPrinter.vulnerable(NODE_MODULE, Const::Cmd::YARN_AUDIT)
            else
              print_success_message "There are no #{NODE_MODULE} vulnerabilities!"
            end
          end
        end

        pkgs.any?
      end

      def outdated # rubocop:disable Metrics/AbcSize, Metrics/MethodLength, Metrics/PerceivedComplexity
        pkgs = []

        if ruby?
          gems = Ruby::GemCollection.outdated
          pkgs += gems
          Printer.new(gems, @options).print(Const::Fields::OUTDATED)

          unless @options[:csv]
            if gems.any?
              Util::SummaryPrinter.total(RUBY_GEM, gems.length)
            else
              print_success_message "There are no outdated #{RUBY_GEM}s!"
            end
          end
        end

        if node?
          npms = Npm::NodeCollection.new(@dir).outdated
          pkgs += npms
          Printer.new(npms, @options).print(Const::Fields::OUTDATED)

          unless @options[:csv]
            if npms.any?
              Util::SummaryPrinter.total(NODE_MODULE, npms.length)
            else
              print_success_message "There are no outdated #{NODE_MODULE}s!"
            end
          end
        end

        pkgs.any?
      end

      def deprecated # rubocop:disable Metrics/AbcSize, Metrics/MethodLength, Metrics/PerceivedComplexity
        pkgs = []

        if ruby?
          gems = Ruby::GemCollection.deprecated
          pkgs += gems
          Printer.new(gems, @options).print(Const::Fields::OUTDATED)

          unless @options[:csv]
            if gems.any?
              Util::SummaryPrinter.total(RUBY_GEM, gems.length)
              Util::SummaryPrinter.deprecated
            else
              print_success_message "There are no potentially deprecated #{RUBY_GEM}s!"
            end
          end
        end

        if node?
          npms = Npm::NodeCollection.new(@dir).deprecated
          pkgs += npms
          Printer.new(npms, @options).print(Const::Fields::OUTDATED)

          unless @options[:csv]
            if npms.any?
              Util::SummaryPrinter.total(NODE_MODULE, npms.length)
              Util::SummaryPrinter.deprecated
            else
              print_success_message "There are no potentially deprecated #{NODE_MODULE}s!"
            end
          end
        end

        pkgs.any?
      end

      private

      def ruby?
        gemfile_present = File.exist?("#{@dir}/#{Const::File::GEMFILE}")
        gemfile_lock_present = File.exist?("#{@dir}/#{Const::File::GEMFILE_LOCK}")

        if gemfile_present && gemfile_lock_present
          true
        elsif gemfile_present
          raise "#{Const::File::GEMFILE_LOCK} was not found in #{@dir}/"
        end
      end

      def node?
        package_json_present = File.exist?("#{@dir}/#{Const::File::PACKAGE_JSON}")
        package_lock_json_present = File.exist?("#{@dir}/#{Const::File::PACKAGE_LOCK_JSON}")
        yarn_lock_present = File.exist?("#{@dir}/#{Const::File::YARN_LOCK}")

        if package_json_present && (package_lock_json_present || yarn_lock_present)
          true
        elsif package_json_present
          raise "#{Const::File::PACKAGE_LOCK_JSON} or #{Const::File::YARN_LOCK} was not found in #{@dir}/"
        end
      end

      def print_success_message(msg)
        puts Util::BashColor.green msg
      end
    end
  end
end
