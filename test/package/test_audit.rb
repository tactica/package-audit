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
      Dir.chdir('test/files') && (output = `../../exe/package-audit`)

      assert_match "Gemfile was not found in #{Dir.pwd}/Gemfile", output
    end

    def test_that_there_is_a_success_message_when_everything_is_up_to_date
      Dir.chdir('test/files/empty') && (output = `../../../exe/package-audit outdated`)

      assert_match 'All gems are at latest versions!', output
    end

    def test_that_there_is_a_success_message_when_there_are_no_vulnerabilities
      Dir.chdir('test/files/empty') && (output = `../../../exe/package-audit vulnerable`)

      assert_match 'No vulnerabilities found!', output
    end

    def test_that_there_is_a_success_message_when_there_are_no_deprecations
      Dir.chdir('test/files/empty') && (output = `../../../exe/package-audit deprecated`)

      assert_match 'No potential deprecated have been found!', output
    end

    def test_that_header_overline_and_underline_are_present
      Dir.chdir('test/files/generic') && (output = `../../../exe/package-audit outdated`)
      lines = output.split("\n")

      assert_equal lines[0], lines[2]
      assert_equal lines[0].length, lines[1].length
    end

    def test_that_every_line_of_output_has_the_same_length
      Dir.chdir('test/files/generic') && (output = `../../../exe/package-audit outdated`)
      lines = output.split("\n")

      assert_equal 21, lines.length
      lines[0..-3].each_with_index { |l, i| assert_equal l[i - 1].length, l[i].length if i.positive? }

      assert_match 'Found a total of 16 gems.', lines[20]
    end

    def test_that_only_explicit_gems_are_displayed
      Dir.chdir('test/files/generic') && (output = `../../../exe/package-audit outdated`)
      lines = output.split("\n")

      assert_equal 7, lines.length
      assert_match(/^fileutils\s+.+$/, lines[3])
      assert_match(/^rails\s+.+$/, lines[4])
      assert_match 'Found a total of 2 gems.', lines[6]
    end

    def test_that_gems_are_shown_in_csv_format_with_headers
      Dir.chdir('test/files/generic') && (output = `../../../exe/package-audit outdated --csv`)
      lines = output.split("\n")

      assert_equal 3, lines.length
      assert_equal 'name,version,latest_version,latest_version_date,vulnerability,risk_type,risk_explanation', lines[0]
      assert_match(/^fileutils,1.5.0,\S+,\d{4}-\d{2}-\d{2},,\S+,.+$/, lines[1])
      assert_match(/^rails,6.1.7.3,\S+,\d{4}-\d{2}-\d{2},,\S+,.+$/, lines[2])
    end

    def test_that_gems_are_shown_in_csv_format_without_headers
      Dir.chdir('test/files/generic') && (output = `../../../exe/package-audit outdated --csv --exclude-headers`)
      lines = output.split("\n")

      assert_equal 2, lines.length
      assert_match(/^fileutils,1.5.0,\S+,\d{4}-\d{2}-\d{2},,\S+,.+$/, lines[0])
      assert_match(/^rails,6.1.7.3,\S+,\d{4}-\d{2}-\d{2},,\S+,.+$/, lines[1])
    end
  end
end
