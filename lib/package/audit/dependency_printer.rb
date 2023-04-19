require_relative './formatter/risk'
require_relative './formatter/version'
require_relative './formatter/version_date'
require_relative './formatter/vulnerability'

module Package
  module Audit
    class DependencyPrinter
      BASH_FORMATTING_REGEX = /\e\[\d+(?:;\d+)*m/

      COLUMN_GAP = 3

      FIELDS = %i[
        name
        version
        version_date
        latest_version
        latest_version_date
        vulnerability
        risk_type
        risk_explanation
      ]

      HEADERS = {
        name: 'Gem',
        version: 'Current',
        latest_version: 'Latest',
        latest_version_date: 'Latest Date',
        vulnerability: 'Vulnerability',
        risk_type: 'Risk',
        risk_explanation: 'Risk Explanation'
      }

      CSV_HEADERS = {
        name: 'package',
        version: 'curr_version',
        version_date: 'version_date',
        latest_version: 'latest_version',
        latest_version_date: 'latest_version_date',
        vulnerability: 'vulnerability',
        risk_type: 'risk',
        risk_explanation: 'risk_explanation'
      }

      def initialize(dependencies, options)
        @dependencies = dependencies
        @options = options
      end

      def print(fields = FIELDS)
        if @options[:csv]
          csv(fields, exclude_headers: @options[:'exclude-headers'])
        else
          pretty(fields)
        end
      end

      private

      def pretty(fields) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
        return if @dependencies.empty?

        # find the maximum length of each field across all the dependencies so we know how many
        # characters of horizontal space to allocate for each field when printing
        fields.each do |key|
          instance_variable_set "@max_#{key}", HEADERS[key].length
          @dependencies.each do |gem|
            curr_field_length = gem.send(key)&.gsub(BASH_FORMATTING_REGEX, '')&.length || 0
            max_field_length = instance_variable_get "@max_#{key}"
            instance_variable_set "@max_#{key}", [curr_field_length, max_field_length].max
          end
        end

        line_length = fields.sum { |key| instance_variable_get "@max_#{key}" } +
                      (COLUMN_GAP * (fields.length - 1))

        puts '=' * line_length
        puts fields.map { |key|
          HEADERS[key].gsub(BASH_FORMATTING_REGEX, '').ljust(instance_variable_get("@max_#{key}"))
        }.join(' ' * COLUMN_GAP)
        puts '=' * line_length

        @dependencies.each do |gem|
          puts fields.map { |key|
            val = gem.send(key) || ''
            val = case key
                  when :risk_type
                    Formatter::Risk.new(gem.risk.type).format
                  when :version
                    Formatter::Version.new(gem.version, gem.latest_version).format
                  when :vulnerability
                    Formatter::Vulnerability.new(gem.vulnerability).format
                  when :latest_version_date
                    Formatter::VersionDate.new(gem.latest_version_date).format
                  else
                    val
                  end

            formatting_length = val.length - val.gsub(BASH_FORMATTING_REGEX, '').length
            val.ljust(instance_variable_get("@max_#{key}") + formatting_length)
          }.join(' ' * COLUMN_GAP)
        end
      end

      def csv(fields, exclude_headers: false)
        return if @dependencies.empty?

        puts fields.map { |field| CSV_HEADERS[field] }.join(',') unless exclude_headers

        @dependencies.map { |gem| puts gem.to_csv(fields) }
      end
    end
  end
end
