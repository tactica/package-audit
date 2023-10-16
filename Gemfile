source 'https://rubygems.org'

ruby '~> 2.7.0'

# Specify your gem's dependencies in package-audit.gemspec
gemspec

group :development do
  gem 'rake'

  # Type Checking
  gem 'rbs', '< 3.2.0' # higher versions do not support Ruby 2.7.x
  gem 'steep'

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
