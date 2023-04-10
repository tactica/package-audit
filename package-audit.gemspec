require_relative 'lib/package/audit/version'

Gem::Specification.new do |spec|
  spec.name = 'package-audit'
  spec.version = Package::Audit::VERSION
  spec.authors = ['Vadim Kononov']
  spec.email = ['support@tactica.ca']

  spec.summary = 'Package audit is a helper tool to find outdated and vulnerable dependencies.'
  spec.description = 'Package audit is designed to find outdated and vulnerable Ruby and Node dependencies.'
  spec.homepage = 'https://github.com/tactica/package-audit'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.6.0'

  spec.metadata['allowed_push_host'] = "Set to your gem server 'https://example.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/tactica/package-audit'

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir.glob('{lib,sig}/**/*', File::FNM_DOTMATCH)
  spec.files << 'bin/package-audit'
  spec.bindir = 'bin'
  spec.executables = ['package-audit']
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  spec.add_dependency 'thor', '~> 1.2'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata['rubygems_mfa_required'] = 'true'
end
