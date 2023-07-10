require 'test_helper'
require_relative '../../../../lib/package/audit/technology/detector'

module Package
  module Audit
    module Technology
      class TestDetector < Minitest::Test
        def setup
          @detector = Technology::Detector.new 'test/files/all'
        end

        def test_that_technologies_are_detected_correctly
          assert_equal [Enum::Technology::NODE, Enum::Technology::RUBY], @detector.detect
        end
      end
    end
  end
end
