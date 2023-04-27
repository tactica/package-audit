require 'json'
require 'net/http'

module Package
  module Audit
    module Npm
      class NpmMetaData
        REGISTRY_URL = 'https://registry.npmjs.org'

        def initialize(packages)
          @packages = packages
        end

        def fetch
          threads = @packages.map do |package|
            Thread.new do
              response = Net::HTTP.get_response(URI.parse("#{REGISTRY_URL}/#{package.name}"))
              raise response.error unless response.is_a?(Net::HTTPSuccess)

              json_package = JSON.parse(response.body, symbolize_names: true)
              update_meta_data(package, json_package)
            end
          end
          threads.each(&:join)
          @packages
        end

        private

        def update_meta_data(package, json_data)
          latest_version = json_data[:'dist-tags'][:latest]
          version_date = json_data[:time][package.version.to_sym]
          latest_version_date = json_data[:time][latest_version.to_sym]
          package.update version_date: Time.parse(version_date).strftime('%Y-%m-%d'),
                         latest_version: latest_version,
                         latest_version_date: Time.parse(latest_version_date).strftime('%Y-%m-%d')
        end
      end
    end
  end
end
