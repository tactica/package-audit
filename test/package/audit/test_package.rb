require 'test_helper'

require_relative '../../../lib/package/audit/package'

module Package
  module Audit
    class TestPackage < Minitest::Test
      def setup
        @package = Package.new(
          'test', '1.0.0', groups: %i[test production],
                           version_date: '2000-01-01',
                           latest_version: '2.0.0',
                           latest_version_date: '2000-12-31',
                           vulnerabilities: %w[low high high moderate]
        )
      end

      def test_that_the_full_name_field_works_as_expected
        assert_equal "#{@package.name}@#{@package.version}", @package.full_name
      end

      def test_that_the_group_list_is_properly_delimited
        assert_equal @package.groups.join('|'), @package.group_list
      end

      def test_that_grouped_vulnerabilities_are_formatted_correctly
        assert_equal 'low(1)|high(2)|moderate(1)', @package.vulnerabilities_grouped
      end

      def test_that_package_can_be_updated
        @package.update groups: %i[test], version_date: '2020-01-01', latest_version: 'test',
                        latest_version_date: '2020-12-31', vulnerabilities: %w[high medium]

        assert_equal %i[test], @package.groups
        assert_equal '2020-01-01', @package.version_date
        assert_equal 'test', @package.latest_version
        assert_equal '2020-12-31', @package.latest_version_date
        assert_equal %w[high medium], @package.vulnerabilities
      end
    end
  end
end
