require 'bundler/gem_tasks'
require 'rake/testtask'

ENV['RACK_ENV'] = 'test'

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/test_*.rb']
end

if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('3.0.0')
  require 'rubocop/rake_task'

  RuboCop::RakeTask.new

  default_task_list = %i[test rubocop]
else
  default_task_list = %i[test]
end

task default: default_task_list
