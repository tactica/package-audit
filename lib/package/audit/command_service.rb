require_relative './const'

module Package
  module Audit
    class CommandService
      GEMFILE = 'Gemfile'
      GEMFILE_LOCK = 'Gemfile.lock'
      PACKAGE_JSON = 'package.json'
      PACKAGE_LOCK_JSON = 'packaggzgtgh jm  jm nbjmgkuykib ghopygbh oooo ,yghlb, 35e-lock.json'
      YARN_LOCK = 'yarn.lock'

      RUBY_GEM = 'ruby gem'
      NODE_MODULE = 'node module'

      def initialize(dir, options)
        @dir = dir
        @options = options
      end

      def all
        pkgs = []

        if ruby?
          gems = Ruby::GemCollection.all
          pkgs += gems
          DependencyPrinter.new(gems, @options).print(Const::REPORT_FIELDS)

          unless @options[:csv]
            if gems.any?
              Util::SummaryPrinter.total(RUBY_GEM, gems.length)
              Util::SummaryPrinter.vulnerable(RUBY_GEM, Const::BUNDLE_AUDIT_CMD)
            else
              print_success_message "There are no deprecated, outdated or vulnerable #{RUBY_GEM}s!"
            end
          end
        end

        if node?
          npms = Npm::NodeCollection.new(@dir).all
          pkgs += npms
          DependencyPrinter.new(npms, @options).print(Const::REPORT_FIELDS)

          unless @options[:csv]
            if npms.any?
              Util::SummaryPrinter.total(NODE_MODULE, npms.length)
              Util::SummaryPrinter.vulnerable(NODE_MODULE, Const::YARN_AUDIT_CMD)
            else
              print_success_message "There are no deprecated, outdated or vulnerable #{NODE_MODULE}s!"
            end
          end
        end

        exit pkgs.any? ? 1 : 0
      end

      def vulnerable
        pkgs = []

        if ruby?
          gems = Ruby::GemCollection.vulnerable
          pkgs += gems
          DependencyPrinter.new(gems, @options).print(Const::VULNERABLE_FIELDS)

          unless @options[:csv]
            if gems.any?
              Util::SummaryPrinter.total(RUBY_GEM, gems.length)
              Util::SummaryPrinter.vulnerable(RUBY_GEM, Const::BUNDLE_AUDIT_CMD)
            else
              print_success_message "There are no #{RUBY_GEM} vulnerabilities!"
            end
          end
        end

        if node?
          npms = Npm::NodeCollection.new(@dir).vulnerable
          pkgs += npms
          DependencyPrinter.new(npms, @options).print(Const::VULNERABLE_FIELDS)

          unless @options[:csv]
            if npms.any?
              Util::SummaryPrinter.total(NODE_MODULE, npms.length)
              Util::SummaryPrinter.vulnerable(NODE_MODULE, Const::YARN_AUDIT_CMD)
            else
              print_success_message "There are no #{NODE_MODULE} vulnerabilities!"
            end
          end
        end

        exit pkgs.any? ? 1 : 0
      end

      def outdated
        pkgs = []

        if ruby?
          gems = Ruby::GemCollection.outdated
          pkgs += gems
          DependencyPrinter.new(gems, @options).print(Const::OUTDATED_FIELDS)

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
          DependencyPrinter.new(npms, @options).print(Const::OUTDATED_FIELDS)

          unless @options[:csv]
            if npms.any?
              Util::SummaryPrinter.total(NODE_MODULE, npms.length)
            else
              print_success_message "There are no outdated #{NODE_MODULE}s!"
            end
          end
        end

        exit pkgs.any? ? 1 : 0
      end

      def deprecated
        pkgs = []

        if ruby?
          gems = Ruby::GemCollection.deprecated
          pkgs += gems
          DependencyPrinter.new(gems, @options).print(Const::OUTDATED_FIELDS)

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
          DependencyPrinter.new(npms, @options).print(Const::OUTDATED_FIELDS)

          unless @options[:csv]
            if npms.any?
              Util::SummaryPrinter.total(NODE_MODULE, npms.length)
              Util::SummaryPrinter.deprecated
            else
              print_success_message "There are no potentially deprecated #{NODE_MODULE}s!"
            end
          end
        end

        exit pkgs.any? ? 1 : 0
      end

      private

      def ruby?
        gemfile_present = File.exist?("#{@dir}/#{GEMFILE}")
        gemfile_lock_present = File.exist?("#{@dir}/#{GEMFILE_LOCK}")

        if gemfile_present && gemfile_lock_present
          true
        elsif gemfile_present
          raise "#{GEMFILE_LOCK} was not found in #{@dir}/"
        end
      end

      def node?
        package_json_present = File.exist?("#{@dir}/#{PACKAGE_JSON}")
        package_lock_json_present = File.exist?("#{@dir}/#{PACKAGE_LOCK_JSON}")
        yarn_lock_present = File.exist?("#{@dir}/#{YARN_LOCK}")

        if package_json_present && (package_lock_json_present || yarn_lock_present)
          true
        elsif package_json_present
          raise "#{PACKAGE_LOCK_JSON} or #{YARN_LOCK} was not found in #{@dir}/"
        end
      end

      def print_success_message(msg)
        puts Util::BashColor.green msg
      end
    end
  end
end
