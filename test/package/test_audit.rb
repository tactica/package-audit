require 'test_helper'

require_relative '../../lib/package/audit/version'
require_relative '../../lib/package/audit/util/summary_printer'

module Package
  class TestAudit < Minitest::Test
    def test_that_it_has_a_version_number
      refute_nil Package::Audit::VERSION
    end

    def test_that_it_returns_a_version_number
      output = `bundle exec package-audit --version`

      assert_match Package::Audit::VERSION, output
    end

    def test_that_it_prints_risk_information
      output = `bundle exec package-audit risk`

      stdout = StringIO.new
      $stdout = stdout
      Package::Audit::Util::SummaryPrinter.risk
      $stdout = STDOUT

      assert_equal stdout.string, output
    end

    def test_that_the_default_version_points_to_report
      assert_equal `bundle exec package-audit report`, `bundle exec package-audit`
    end

    def test_that_there_is_a_success_message_when_report_is_empty
      output = `bundle exec package-audit report`

      assert_match 'There are no deprecated, outdated or vulnerable ruby gems!', output
    end

    def test_that_there_is_a_success_message_when_everything_is_up_to_date
      output = `bundle exec package-audit outdated`

      assert_match 'There are no outdated ruby gems!', output
    end

    def test_that_there_is_a_success_message_when_there_are_no_vulnerabilities
      output = `bundle exec package-audit vulnerable`

      assert_match 'There are no ruby gem vulnerabilities!', output
    end

    def test_that_there_is_a_success_message_when_there_are_no_deprecations
      output = `bundle exec package-audit deprecated`

      assert_match 'There are no potentially deprecated ruby gems!', output
    end
  end
end
