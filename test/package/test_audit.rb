require 'test_helper'

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
      output = `bundle exec package-audit outdated test/files/not_found`
      assert_match 'No such file or directory @ rb_sysopen - test/files/not_found/Gemfile.lock', output
    end

    def test_that_there_is_an_error_message_when_a_file_is_invalid
      output = `bundle exec package-audit outdated test/files/invalid`
      assert_match 'NoMethodError', output
    end

    def test_that_there_is_a_success_message_when_everything_is_up_to_date
      output = `bundle exec package-audit outdated test/files/empty`
      assert_match 'Bundle up to date!', output
    end

    def test_that_headers_are_correct_and_present
      output = `bundle exec package-audit outdated test/files/generic`
      lines = output.split(/\n/)
      assert_equal lines[0], lines[2]
      assert_equal lines[0].length, lines[1].length
    end

    def test_that_every_line_of_output_has_the_same_length
      output = `bundle exec package-audit outdated test/files/generic`
      lines = output.split(/\n/)
      assert_equal 19, lines.length
      lines.each_with_index { |l, i| assert_equal l[i - 1].length, l[i].length if i.positive? }
    end

    def test_that_only_explicit_gems_are_displayed
      output = `bundle exec package-audit outdated test/files/generic --only-explicit`
      lines = output.split(/\n/)
      assert_equal 5, lines.length
      assert_match(/^fileutils\s+1.5.0\s+\S+\s+\d{4}-\d{2}-\d{2}\s$/, lines[3])
      assert_match(/^rails\s+6.1.7.3\s+\S+\s+\d{4}-\d{2}-\d{2}\s$/, lines[4])
    end

    def test_that_gems_are_shown_in_csv_format_with_headers
      output = `bundle exec package-audit outdated test/files/generic --only-explicit --csv`
      lines = output.split(/\n/)
      assert_equal 3, lines.length
      assert_equal 'package,curr_version,latest_version,latest_version_date', lines[0]
      assert_match(/^fileutils,1.5.0,2020-12-22,\S+,\d{4}-\d{2}-\d{2}$/, lines[1])
      assert_match(/^rails,6.1.7.3,2023-03-13,\S+,\d{4}-\d{2}-\d{2}$/, lines[2])
    end

    def test_that_gems_are_shown_in_csv_format_without_headers
      output = `bundle exec package-audit outdated test/files/generic --only-explicit --csv --exclude-headers`
      lines = output.split(/\n/)
      assert_equal 2, lines.length
      assert_match(/^fileutils,1.5.0,2020-12-22,\S+,\d{4}-\d{2}-\d{2}$/, lines[0])
      assert_match(/^rails,6.1.7.3,2023-03-13,\S+,\d{4}-\d{2}-\d{2}$/, lines[1])
    end
  end
end
