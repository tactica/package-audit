require 'test_helper'
require_relative '../../../../lib/package/audit/services/command_parser'

module Package
  module Audit
    class TestCommandParser < Minitest::Test
      def test_that_an_error_is_shown_when_config_file_not_found
        ex = assert_raises ArgumentError do
          CommandParser.new '.', { 'config' => 'unknown' }, Enum::Report::ALL
        end

        assert_equal 'Configuration file not found: unknown', ex.message
      end

      def test_that_an_error_is_shown_for_an_unsupported_technology
        ex = assert_raises ArgumentError do
          CommandParser.new '.', { 'technology' => ['invalid'] }, Enum::Report::ALL
        end

        assert_equal "\"invalid\" is not a supported technology, use one of #{Enum::Technology.all}", ex.message
      end
    end
  end
end
