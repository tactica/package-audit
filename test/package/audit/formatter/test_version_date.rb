require_relative '../../../../lib/package/audit/formatter/version_date'
require_relative '../../../../lib/package/audit/util/bash_color'

require 'test_helper'

module Package
  module Audit
    module Formatter
      class TestVersionDate < Minitest::Test
        def test_that_todays_date_has_no_special_color
          date = Date.today.strftime('%Y-%m-%d')
          format = VersionDate.new(date).format

          assert_equal date, format
        end

        def test_that_date_within_accepted_interval_has_no_special_color
          one_day_in_seconds = 86_400 # assuming a 24-hour day
          time_in_seconds = (Time.now.to_i - (Const::Time::SECONDS_ELAPSED_TO_BE_OUTDATED - one_day_in_seconds))
          date = Time.zone.at(time_in_seconds).strftime('%Y-%m-%d')
          format = VersionDate.new(date).format

          assert_equal date, format
        end

        def test_that_date_outside_accepted_interval_is_in_color
          time_in_seconds = (Time.now.to_i - Const::Time::SECONDS_ELAPSED_TO_BE_OUTDATED)
          date = Time.zone.at(time_in_seconds).strftime('%Y-%m-%d')
          format = VersionDate.new(date).format

          assert_equal Util::BashColor.yellow(date), format
        end
      end
    end
  end
end
