require 'test_helper'

require_relative '../../../lib/package/audit/dependency_printer'

module Package
  module Audit
    class TestDependencyPrinter < Minitest::Test
      def test_that_headers_match_field_names
        assert_equal DependencyPrinter::FIELDS.sort, DependencyPrinter::HEADERS.keys.sort
      end
    end
  end
end
