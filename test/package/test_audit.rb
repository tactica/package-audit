require 'test_helper'

module Package
  class TestAudit < Minitest::Test
    def test_that_it_has_a_version_number
      refute_nil Package::Audit::VERSION
    end

    def test_that_it_can_run_as_an_executable
      assert system 'bundle exec package-audit --version'
    end

    def test_that_there_is_a_success_message
      system 'bundle exec package-audit outdated test/files/empty_gemfile'
    end
  end
end
