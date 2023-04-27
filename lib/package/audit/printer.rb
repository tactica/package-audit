require_relative './const'
require_relative './formatter/risk'
require_relative './formatter/version'
require_relative './formatter/version_date'
require_relative './formatter/vulnerability'

module Package
  module Audit
    class Printer
      BASH_FORMATTING_REGEX = /\e\[\d+(?:;\d+)*m/

      COLUMN_GAP = 2

      def initialize(pkgs, options)
        @pkgs = pkgs
        @options = options
      end

      def print(fields)
        if (fields - Const::FIELDS).any?
          raise ArgumentError,
                "#{fields - Const::FIELDS} are not valid field names. Available fields names are: #{Const::FIELDS}."
        end

        return if @pkgs.empty?

        if @options[:csv]
          csv(fields, exclude_headers: @options[:'exclude-headers'])
        else
          pretty(fields)
        end
        puts
      end

      private

      def pretty(fields = Const::REPORT_FIELDS) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
        # find the maximum length of each field across all the packages so we know how many
        # characters of horizontal space to allocate for each field when printing
        fields.each do |key|
          instance_variable_set "@max_#{key}", Const::HEADERS[key].length
          @pkgs.each do |gem|
            curr_field_length = case key
                                when :vulnerabilities
                                  gem.vulnerabilities_grouped.length
                                when :groups
                                  gem.group_list.length
                                else
                                  gem.send(key)&.gsub(BASH_FORMATTING_REGEX, '')&.length || 0
                                end
            max_field_length = instance_variable_get "@max_#{key}"
            instance_variable_set "@max_#{key}", [curr_field_length, max_field_length].max
          end
        end

        line_length = fields.sum { |key| instance_variable_get "@max_#{key}" } +
                      (COLUMN_GAP * (fields.length - 1))

        puts '=' * line_length
        puts fields.map { |key|
          Const::HEADERS[key].gsub(BASH_FORMATTING_REGEX, '').ljust(instance_variable_get("@max_#{key}"))
        }.join(' ' * COLUMN_GAP)
        puts '=' * line_length

        @pkgs.each do |pkg|
          puts fields.map { |key|
            val = pkg.send(key) || ''
            val = case key
                  when :groups
                    pkg.group_list
                  when :risk_type
                    Formatter::Risk.new(pkg.risk_type).format
                  when :version
                    Formatter::Version.new(pkg.version, pkg.latest_version).format
                  when :vulnerabilities
                    Formatter::Vulnerability.new(pkg.vulnerabilities).format
                  when :latest_version_date
                    Formatter::VersionDate.new(pkg.latest_version_date).format
                  else
                    val
                  end

            formatting_length = val.length - val.gsub(BASH_FORMATTING_REGEX, '').length
            val.ljust(instance_variable_get("@max_#{key}") + formatting_length)
          }.join(' ' * COLUMN_GAP)
        end
      end

      def csv(fields, exclude_headers: false)
        value_fields = fields.map do |field|
          case field
          when :groups
            :group_list
          when :vulnerabilities
            :vulnerabilities_grouped
          else
            field
          end
        end

        puts fields.join(',') unless exclude_headers
        @pkgs.map { |gem| puts gem.to_csv(value_fields) }
      end
    end
  end
end