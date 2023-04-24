require 'test_helper'

require_relative '../../lib/package/audit/version'

module Package
  class TestAudit < Minitest::Test
    def test_that_it_has_a_version_number
      refute_nil Package::Audit::VERSION
    end

    def test_that_it_can_run_as_an_executable
      output = `bundle exec package-audit --version`
      assert_match Package::Audit::VERSION, output
    end

    def test_that_there_is_an_error_message_when_a_file_is_not_found
      Dir.chdir('test/files') && (output = `../../exe/package-audit`)
      assert_match "Gemfile was not found in #{Dir.pwd}/Gemfile", output
      Dir.chdir('../../')
    end

    def test_that_the_default_version_points_to_report
      assert_equal `bundle exec package-audit report`, `bundle exec package-audit`
    end

    def test_that_there_is_a_success_message_when_report_is_empty
      output = `bundle exec package-audit report`
      assert_match 'There are no deprecated, outdated or vulnerable gems!', output
    end

    def test_that_there_is_a_success_message_when_everything_is_up_to_date
      output = `bundle exec package-audit outdated`
      assert_match 'All gems are at latest versions!', output
    end

    def test_that_there_is_a_success_message_when_there_are_no_vulnerabilities
      output = `bundle exec package-audit vulnerable`
      assert_match 'No vulnerabilities found!', output
    end

    def test_that_there_is_a_success_message_when_there_are_no_deprecations
      output = `bundle exec package-audit deprecated`
      assert_match 'No potential deprecated have been found!', output
    end
  end
end
