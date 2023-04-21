require 'test_helper'

require_relative '../../../lib/package/audit/dependency_printer'

module Package
  module Audit
    class TestDependencyPrinter < Minitest::Test
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
    end
  end
end
