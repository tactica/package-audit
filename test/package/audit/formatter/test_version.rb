require 'test_helper'

require_relative '../../../../lib/package/audit/formatter/version'
require_relative '../../../../lib/package/audit/util/bash_color'

module Package
  module Audit
    module Formatter
      class TestVersion < Minitest::Test
        def test_that_same_version_has_no_special_color
          format = Version.new('version', 'version').format

          assert_equal 'version', format
        end

        def test_that_1_part_major_version_difference_is_in_color
          format = Version.new('1', '2').format

          assert_equal Util::BashColor.orange('1'), format
        end

        def test_that_2_part_major_version_difference_is_in_color
          format = Version.new('1.2', '2.2').format

          assert_equal Util::BashColor.orange('1.2'), format
        end

        def test_that_2_part_minor_version_difference_is_in_color
          format = Version.new('1.2', '1.3').format

          assert_equal "1.#{Util::BashColor.yellow('2')}", format
        end

        def test_that_3_part_major_version_difference_is_in_color
          format = Version.new('1.2.3', '2.2.3').format

          assert_equal Util::BashColor.orange('1.2.3'), format
        end

        def test_that_3_part_minor_version_difference_is_in_color
          format = Version.new('1.2.3', '1.3.3').format

          assert_equal "1.#{Util::BashColor.yellow('2.3')}", format
        end

        def test_that_3_part_patch_version_difference_is_in_color
          format = Version.new('1.2.3', '1.2.4').format

          assert_equal "1.2.#{Util::BashColor.green('3')}", format
        end

        def test_that_4_part_major_version_difference_is_in_color
          format = Version.new('1.2.3.4', '2.2.3.4').format

          assert_equal Util::BashColor.orange('1.2.3.4'), format
        end

        def test_that_4_part_minor_version_difference_is_in_color
          format = Version.new('1.2.3.4', '1.3.3.4').format

          assert_equal "1.#{Util::BashColor.yellow('2.3.4')}", format
        end

        def test_that_4_part_patch_version_difference_is_in_color
          format = Version.new('1.2.3.4', '1.2.4.4').format

          assert_equal "1.2.#{Util::BashColor.green('3.4')}", format
        end

        def test_that_4_part_build_version_difference_is_in_color
          format = Version.new('1.2.3.4', '1.2.3.5').format

          assert_equal "1.2.3.#{Util::BashColor.green('4')}", format
        end
      end
    end
  end
end
