require 'test_helper'
require 'stringio'

require_relative '../../../lib/package/audit/util/bash_color'
require_relative '../../../lib/package/audit/dependency_printer'
require_relative '../../../lib/package/audit/formatter/vulnerability'
require_relative '../../../lib/package/audit/dependency'

module Package
  module Audit
    class TestDependencyPrinter < Minitest::Test
      def setup
        @today = Time.now.strftime('%Y-%m-%d')
        @fileutils = Dependency.new 'fileutils', '1.5.0'
        @fileutils.update latest_version: '1.7.1', latest_version_date: @today, groups: %i[default]
        @rails = Dependency.new 'rails', '6.0.0'
        @rails.update latest_version: '7.0.4.3', latest_version_date: @today, groups: %i[default],
                      vulnerabilities: [Enum::VulnerabilityType::MEDIUM, Enum::VulnerabilityType::HIGH, Enum::VulnerabilityType::HIGH]
        @puma = Dependency.new 'puma', '5.1.1'
        @puma.update latest_version: '5.1.1', latest_version_date: '2020-12-10', groups: %i[development test]
        @gems = [@fileutils, @puma, @rails]

        @output = StringIO.new
        $stdout = @output
      end

      def teardown
        $stdout = STDOUT
      end

      def test_that_headers_match_field_names
        assert_equal DependencyPrinter::FIELDS.sort, DependencyPrinter::HEADERS.keys.sort
      end

      def test_that_an_error_is_shown_for_invalid_fields
        fields = %i[name version unknown]
        exp_error = "[:invalid] are not valid field names. Available fields names are: #{DependencyPrinter::FIELDS}."
        assert_raises ArgumentError, exp_error do
          DependencyPrinter.new([], {}).print(fields)
        end
      end

      def test_that_the_dependencies_are_displayed_correctly
        DependencyPrinter.new(@gems, {}).print(%i[name version latest_version latest_version_date])
        lines = @output.string.split("\n")

        assert_equal 6, lines.length
        assert_equal "fileutils  1.#{Util::BashColor.yellow('5.0')}    1.7.1    #{@today} ", lines[3]
        assert_equal "puma       5.1.1    5.1.1    #{Util::BashColor.yellow('2020-12-10')} ", lines[4]
        assert_equal "rails      #{Util::BashColor.orange('6.0.0')}    7.0.4.3  #{@today} ", lines[5]
      end

      def test_that_the_dependencies_are_displayed_correctly_in_csv_with_headers
        columns = %i[name version latest_version groups]
        DependencyPrinter.new(@gems, {csv: true}).print(columns)
        lines = @output.string.split("\n")

        assert_equal @gems.length + 1, lines.length
        assert_equal columns.join(','), lines[0]

        @gems.each_with_index do |gem, index|
          assert_equal "#{gem.name},#{gem.version},#{gem.latest_version},#{gem.group_list}", lines[index + 1]
        end
      end

      def test_that_vulnerabilities_are_displayed_correctly
        DependencyPrinter.new([@rails], {}).print(%i[vulnerabilities])
        lines = @output.string.split("\n")

        assert_equal Formatter::Vulnerability.new(@rails.vulnerabilities).format, lines[3]
      end

      def test_that_vulnerabilities_are_displayed_correctly_in_csv
        DependencyPrinter.new([@rails], {csv: true}).print(%i[vulnerabilities])
        lines = @output.string.split("\n")

        assert_equal 'medium(1)|high(2)', lines[1]
      end
    end
  end
end
