require 'test_helper'
require_relative '../../../lib/package/audit/enum/group'

require 'bundler'

module Package
  module Audit
    class TestGroup < Minitest::Test
      def test_that_no_group_produces_expected_output
        output = `bundle exec package-audit test/files/gemfile/groups`

        %w[irb minitest rack reline tzinfo yard].each { |pkg| assert_match pkg, output }
        assert_match 'Found a total of 6 ruby packages.', output
      end

      def test_that_default_group_produces_expected_output
        output = `bundle exec package-audit test/files/gemfile/groups -g default`

        %w[irb rack reline].each { |pkg| assert_match pkg, output }
        assert_match 'Found a total of 3 ruby packages.', output
      end

      def test_that_development_group_produces_expected_output
        output = `bundle exec package-audit test/files/gemfile/groups -g development`

        %w[irb rack reline yard].each { |pkg| assert_match pkg, output }
        assert_match 'Found a total of 4 ruby packages.', output
      end

      def test_that_test_group_produces_expected_output
        output = `bundle exec package-audit test/files/gemfile/groups -g test`

        %w[irb minitest rack reline].each { |pkg| assert_match pkg, output }
        assert_match 'Found a total of 4 ruby packages.', output
      end

      def test_that_production_group_produces_expected_output
        output = `bundle exec package-audit test/files/gemfile/groups -g production`

        %w[irb rack reline tzinfo].each { |pkg| assert_match pkg, output }
        assert_match 'Found a total of 4 ruby packages.', output
      end

      def test_that_multiple_groups_produces_expected_output
        output = `bundle exec package-audit test/files/gemfile/groups -g test -g production`

        %w[irb minitest rack reline tzinfo].each { |pkg| assert_match pkg, output }
        assert_match 'Found a total of 5 ruby packages.', output
      end
    end
  end
end
