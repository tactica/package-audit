module Package
  module Audit
    module Npm
      class YarnLockParser
        def initialize(yarn_lock_path)
          @yarn_lock_path = File.read(yarn_lock_path)
        end

        def fetch(default_deps, dev_deps)
          pkgs = []
          default_deps.merge(dev_deps).each do |dep_name, expected_version|
            pkg_block = fetch_package_block(dep_name, expected_version)
            version = fetch_package_version(dep_name, pkg_block)
            pks = Package.new(dep_name.to_s, version)
            pks.update groups: dev_deps.key?(dep_name) ? %i[development] : %i[default development]
            pkgs << pks
          end
          pkgs
        end

        private

        def fetch_package_block(dep_name, expected_version)
          regex = /#{Regexp.escape(dep_name)}@#{Regexp.escape(expected_version)}.*?:.*?(\n\n|\z)/m
          blocks = @yarn_lock_path.match(regex)
          if blocks.nil? || blocks[0].nil?
            raise NoMatchingPatternError, "Unable to find #{dep_name} in #{@yarn_lock_path}"
          end

          blocks[0] || ''
        end

        def fetch_package_version(dep_name, pkg_block)
          version = pkg_block.match(/version "(.*?)"/)&.[](1)
          raise NoMatchingPatternError, "Unable to find #{dep_name} version in #{@yarn_lock_path}" if version.nil?

          version || '0.0.0.0'
        end
      end
    end
  end
end
