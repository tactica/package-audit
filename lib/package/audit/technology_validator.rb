require_relative 'enum/technology'

module Package
  module Audit
    class TechnologyValidator
      SUPPORTED_TECH = Enum::Technology.constants.map { |key| Enum::Technology.const_get(key) }.sort

      def initialize(dir)
        @dir = dir
      end

      def validate!(technology)
        case technology
        when Enum::Technology::NODE
          validate_node!
        when Enum::Technology::RUBY
          validate_ruby!
        else
          puts Util::BashColor.red("\"#{technology}\" is not a supported technology, use one of #{SUPPORTED_TECH}")
          exit 1
        end
      end

      private

      def validate_node!
        package_json_present = File.exist?("#{@dir}/#{Const::File::PACKAGE_JSON}")
        package_lock_json_present = File.exist?("#{@dir}/#{Const::File::PACKAGE_LOCK_JSON}")
        yarn_lock_present = File.exist?("#{@dir}/#{Const::File::YARN_LOCK}")

        unless package_json_present
          puts Util::BashColor.red("\"#{Const::File::PACKAGE_JSON}\" was not found in #{@dir}")
        end
        unless package_lock_json_present || yarn_lock_present
          puts Util::BashColor.red("\"#{Const::File::PACKAGE_LOCK_JSON}\" or \"#{Const::File::YARN_LOCK}\" was not found in #{@dir}")
        end

        exit 1 unless package_json_present && (package_lock_json_present || yarn_lock_present)
      end

      def validate_ruby!
        gemfile_present = File.exist?("#{@dir}/#{Const::File::GEMFILE}")
        gemfile_lock_present = File.exist?("#{@dir}/#{Const::File::GEMFILE_LOCK}")

        puts Util::BashColor.red("\"#{Const::File::GEMFILE}\" was not found in #{@dir}") unless gemfile_present
        unless gemfile_lock_present
          puts Util::BashColor.red("\"#{Const::File::GEMFILE_LOCK}\" was not found in #{@dir}")
        end

        exit 1 unless gemfile_present && gemfile_lock_present
      end
    end
  end
end
