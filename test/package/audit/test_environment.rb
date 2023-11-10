require 'test_helper'
require_relative '../../../lib/package/audit/enum/environment'

require 'bundler'

module Package
  module Audit
    class TestEnvironment < Minitest::Test
      def test_that_it_returns_an_error_for_invalid_environments
        output = `bundle exec package-audit -e invalid`

        assert_match 'ArgumentError: ["invalid"] is not valid list of environments', output
        assert_match "use one of #{Enum::Environment.all}", output
      end

      def test_that_no_environment_produces_expected_output
        output = `bundle exec package-audit report test/files/gemfile/environments`

        %w[irb minitest rack reline tzinfo yard].each { |pkg| assert_match pkg, output }
        assert_match 'Found a total of 6 ruby packages.', output
      end

      def test_that_default_environment_produces_expected_output
        output = `bundle exec package-audit report test/files/gemfile/environments -e default`

        %w[irb rack reline].each { |pkg| assert_match pkg, output }
        assert_match 'Found a total of 3 ruby packages.', output
      end

      def test_that_development_environment_produces_expected_output
        output = `bundle exec package-audit report test/files/gemfile/environments -e development`

        %w[irb rack reline yard].each { |pkg| assert_match pkg, output }
        assert_match 'Found a total of 4 ruby packages.', output
      end

      def test_that_test_environment_produces_expected_output
        output = `bundle exec package-audit report test/files/gemfile/environments -e test`

        %w[irb minitest rack reline].each { |pkg| assert_match pkg, output }
        assert_match 'Found a total of 4 ruby packages.', output
      end

      def test_that_production_environment_produces_expected_output
        output = `bundle exec package-audit report test/files/gemfile/environments -e production`

        %w[irb rack reline tzinfo].each { |pkg| assert_match pkg, output }
        assert_match 'Found a total of 4 ruby packages.', output
      end

      def test_that_multiple_environments_produces_expected_output
        output = `bundle exec package-audit report test/files/gemfile/environments -e test -e production`

        %w[irb minitest rack reline tzinfo].each { |pkg| assert_match pkg, output }
        assert_match 'Found a total of 5 ruby packages.', output
      end
    end
  end
end
