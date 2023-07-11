require 'test_helper'
require_relative '../../../../lib/package/audit/services/package_filter'

module Package
  module Audit
    class TestPackageFilter < Minitest::Test
      def setup
        config = YAML.load_file('test/files/config/.package-audit.yml')
        @filter = PackageFilter.new(config)
      end

      def test_that_outdated_packaged_are_ignored
        @pkg1 = Package.new('test', '0.30.0', Enum::Technology::RUBY, latest_version: '0.30.2')
        @pkg2 = Package.new('test', '0.30.1', Enum::Technology::RUBY, latest_version: '0.30.2')

        assert_predicate @pkg1, :outdated?
        assert @filter.ignored?(@pkg1)
        assert_predicate @pkg2, :outdated?
        refute @filter.ignored?(@pkg2)
      end

      def test_that_deprecated_packaged_are_ignored
        @pkg1 = Package.new('test', '0.30.0', Enum::Technology::RUBY, latest_version_date: '2020-01-01')
        @pkg2 = Package.new('test', '0.30.1', Enum::Technology::RUBY, latest_version_date: '2020-01-01')

        assert_predicate @pkg1, :deprecated?
        assert @filter.ignored?(@pkg1)
        assert_predicate @pkg2, :deprecated?
        refute @filter.ignored?(@pkg2)
      end

      def test_that_outdated_packages_are_not_ignored_if_deprecated
        @pkg = Package.new('test2', '1.0.0', Enum::Technology::RUBY, latest_version: '1.0.1')

        assert_predicate @pkg, :outdated?
        assert_predicate @pkg, :deprecated?
        refute @filter.ignored?(@pkg)
      end
    end
  end
end
