require 'yaml'

require_relative 'const/cmd'
require_relative 'const/file'
require_relative 'enum/report'
require_relative 'enum/technology'

module Package
  module Audit
    class TechnologyDetector
      def initialize(dir)
        @dir = dir
      end

      def detect
        technologies = []
        technologies << Enum::Technology::RUBY if ruby?
        technologies << Enum::Technology::NODE if node?
        technologies.sort
      end

      private

      def node?
        package_json_present = File.exist?("#{@dir}/#{Const::File::PACKAGE_JSON}")
        package_lock_json_present = File.exist?("#{@dir}/#{Const::File::PACKAGE_LOCK_JSON}")
        yarn_lock_present = File.exist?("#{@dir}/#{Const::File::YARN_LOCK}")
        package_json_present && (package_lock_json_present || yarn_lock_present)
      end

      def ruby?
        gemfile_present = File.exist?("#{@dir}/#{Const::File::GEMFILE}")
        gemfile_lock_present = File.exist?("#{@dir}/#{Const::File::GEMFILE_LOCK}")
        gemfile_present && gemfile_lock_present
      end
    end
  end
end
