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

        def test_that_gemfile_is_missing
          validator = Technology::Validator.new 'test/files/gemfile'

          ex = assert_raises RuntimeError do
            validator.validate! Enum::Technology::RUBY
          end

          assert_equal '"Gemfile" was not found in test/files/gemfile', ex.message
        end

        def test_that_gemfile_lock_is_missing
          validator = Technology::Validator.new 'test/files/gemfile/missing_gemfile_lock'

          ex = assert_raises RuntimeError do
            validator.validate! Enum::Technology::RUBY
          end

          assert_equal '"Gemfile.lock" was not found in test/files/gemfile/missing_gemfile_lock', ex.message
        end

        def test_that_package_json_file_is_missing
          validator = Technology::Validator.new 'test/files/node'

          ex = assert_raises RuntimeError do
            validator.validate! Enum::Technology::NODE
          end

          assert_equal '"package.json" was not found in test/files/node', ex.message
        end

        def test_that_node_lock_file_is_missing
          validator = Technology::Validator.new 'test/files/node/missing_lock_file'

          ex = assert_raises RuntimeError do
            validator.validate! Enum::Technology::NODE
          end

          assert_equal '"package-lock.json" or "yarn.lock" was not found in test/files/node/missing_lock_file',
                       ex.message
        end
      end
    end
  end
end
