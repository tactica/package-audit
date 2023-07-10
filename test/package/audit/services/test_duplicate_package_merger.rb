require 'test_helper'
require_relative '../../../../lib/package/audit/models/package'
require_relative '../../../../lib/package/audit/enum/technology'
require_relative '../../../../lib/package/audit/services/duplicate_package_merger'

module Package
  module Audit
    class TestDuplicatePackageMerger < Minitest::Test
      def setup
        pkg1 = Package.new('test', '1.0.0', Enum::Technology::RUBY, groups: %w[group1], vulnerabilities: %w[vuln1])
        pkg2 = Package.new('test', '1.0.0', Enum::Technology::RUBY, groups: %w[group1 group2],
                                                                    vulnerabilities: %w[vuln1 vuln2])
        pkg3 = Package.new('test', '1.0.0', Enum::Technology::RUBY, groups: %w[group2 group3],
                                                                    vulnerabilities: %w[vuln2 vuln3])
        pkg4 = Package.new('test', '1.0.1', Enum::Technology::RUBY)
        @merger = DuplicatePackageMerger.new([pkg1, pkg2, pkg3, pkg4])
      end

      def test_that_all_duplicated_packaged_are_merged
        pkgs = @merger.run

        assert_equal 2, pkgs.length
      end

      def test_that_only_packages_with_the_same_version_are_merged
        pkgs = @merger.run

        assert_equal '1.0.0', pkgs.first.version
        assert_equal '1.0.1', pkgs.last.version
      end

      def test_that_all_groups_are_combined
        pkgs = @merger.run

        assert_equal %w[group1 group2 group3], pkgs.first.groups
      end

      def test_that_all_vulnerabilities_are_combined
        pkgs = @merger.run

        assert_equal %w[vuln1 vuln1 vuln2 vuln2 vuln3], pkgs.first.vulnerabilities
      end
    end
  end
end
