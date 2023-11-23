require 'test_helper'

require 'bundler'

module Package
  module Audit
    class TestErrors < Minitest::Test
      def test_that_it_prints_an_error_about_a_file_instead_of_a_directory
        output = `bundle exec package-audit test/files/gemfile/report/Gemfile`

        assert_match '"test/files/gemfile/report/Gemfile" is a file instead of directory', output
      end

      def test_that_it_prints_an_error_about_a_non_existing_directory
        output = `bundle exec package-audit test/files/gemfile/report/invalid`

        assert_match '"test/files/gemfile/report/invalid" is not a valid directory', output
      end

      def test_that_it_prints_an_error_when_no_supported_technologies_are_found
        output = `bundle exec package-audit test/files/`

        assert_match 'No supported technologies found in this directory', output
      end
    end
  end
end
