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

      def test_that_attributes_can_be_updated
        @package.update groups: %i[test], version_date: '2020-01-01', latest_version: 'test',
                        latest_version_date: '2020-12-31', vulnerabilities: %w[high medium]

        assert_equal %i[test], @package.groups
        assert_equal '2020-01-01', @package.version_date
        assert_equal 'test', @package.latest_version
        assert_equal '2020-12-31', @package.latest_version_date
        assert_equal %w[high medium], @package.vulnerabilities
      end

      # def test_that_it_returns_a_version_number
      #   output = `bundle exec package-audit --version`
      #
      #   assert_match Package::Audit::VERSION, output
      # end
      #
      # def test_that_it_prints_risk_information
      #   output = `bundle exec package-audit risk`
      #
      #   stdout = StringIO.new
      #   $stdout = stdout
      #   Package::Audit::Util::SummaryPrinter.risk
      #   $stdout = STDOUT
      #
      #   assert_equal stdout.string, output
      # end
      #
      # def test_that_there_is_an_error_message_when_a_file_is_not_found
      #   Dir.chdir('test') && (output = `../exe/package-audit`)
      #
      #   assert_match "Gemfile was not found in #{Dir.pwd}/Gemfile", output
      #   Dir.chdir('../')
      # end
      #
      # def test_that_the_default_version_points_to_report
      #   assert_equal `bundle exec package-audit report`, `bundle exec package-audit`
      # end
      #
      # def test_that_there_is_a_success_message_when_report_is_empty
      #   output = `bundle exec package-audit report`
      #
      #   assert_match 'There are no deprecated, outdated or vulnerable gems!', output
      # end
      #
      # def test_that_there_is_a_success_message_when_everything_is_up_to_date
      #   output = `bundle exec package-audit outdated`
      #
      #   assert_match 'All gems are at latest versions!', output
      # end
      #
      # def test_that_there_is_a_success_message_when_there_are_no_vulnerabilities
      #   output = `bundle exec package-audit vulnerable`
      #
      #   assert_match 'No vulnerabilities found!', output
      # end
      #
      # def test_that_there_is_a_success_message_when_there_are_no_deprecations
      #   output = `bundle exec package-audit deprecated`
      #
      #   assert_match 'No potential deprecated have been found!', output
      # end
    end
  end
end
