require 'test_helper'
require_relative '../../../../lib/package/audit/technology/validator'

module Package
  module Audit
    module Technology
      class TestValidator < Minitest::Test
        def setup
          @validator = Technology::Validator.new 'test/files/all'
        end

        def test_that_an_error_is_shown_for_an_unsupported_technology
          ex = assert_raises ArgumentError do
            @validator.validate! 'invalid'
          end

          assert_equal "\"invalid\" is not a supported technology, use one of #{Enum::Technology.all}", ex.message
        end

        def test_that_technologies_are_validated_correctly
          @validator.validate! Enum::Technology::NODE
          @validator.validate! Enum::Technology::RUBY
        end
      end
    end
  end
end
