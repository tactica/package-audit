source 'https://rubygems.org'

# Specify your gem's dependencies in package-audit.gemspec
gemspec

group :development do
  gem 'rake'

  # Type Checking
  if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('3.0.0')
    gem 'steep'

    # Code Linting
    gem 'rubocop', require: false
    gem 'rubocop-md', require: false
    gem 'rubocop-minitest', require: false
    gem 'rubocop-performance', require: false
    gem 'rubocop-rake', require: false
  end
end

group :test do
  gem 'minitest'
end
