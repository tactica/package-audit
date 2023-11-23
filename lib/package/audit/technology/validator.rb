require_relative '../const/file'
require_relative '../enum/technology'

module Package
  module Audit
    module Technology
      class Validator
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
            raise ArgumentError, "\"#{technology}\" is not a supported technology, " \
                                 "use one of #{Enum::Technology.all}"
          end
        end

        private

        def validate_node!
          package_json_present = File.exist?("#{@dir}/#{Const::File::PACKAGE_JSON}")
          package_lock_json_present = File.exist?("#{@dir}/#{Const::File::PACKAGE_LOCK_JSON}")
          yarn_lock_present = File.exist?("#{@dir}/#{Const::File::YARN_LOCK}")

          raise "\"#{Const::File::PACKAGE_JSON}\" was not found in #{@dir}" unless package_json_present

          return if package_lock_json_present || yarn_lock_present

          raise "\"#{Const::File::PACKAGE_LOCK_JSON}\" or \"#{Const::File::YARN_LOCK}\" " \
                "was not found in #{@dir}"
        end

        def validate_ruby!
          gemfile_present = File.exist?("#{@dir}/#{Const::File::GEMFILE}")
          gemfile_lock_present = File.exist?("#{@dir}/#{Const::File::GEMFILE_LOCK}")

          raise "\"#{Const::File::GEMFILE}\" was not found in #{@dir}" unless gemfile_present
          raise "\"#{Const::File::GEMFILE_LOCK}\" was not found in #{@dir}" unless gemfile_lock_present
        end
      end
    end
  end
end
