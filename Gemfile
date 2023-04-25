source 'https://rubygems.org'

# Specify your gem's dependencies in package-audit.gemspec
gemspec

group :development do
  gem 'rake'

  # Type Checking
  gem 'activesupport', '< 7.0.0.0'
  gem 'parallel', '1.22.1'
  gem 'parser', '3.2.2.0'
  gem 'steep', '1.3.2'

  # Code Linting
  gem 'rubocop', require: false
  gem 'rubocop-md', require: false
  gem 'rubocop-minitest', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rake', require: false
end

group :test do
  gem 'minitest'
end
