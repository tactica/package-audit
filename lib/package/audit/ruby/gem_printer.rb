module Package
  module Audit
    module Ruby
      class GemPrinter
        COLUMN_GAP = 3

        FIELDS = %i[name curr_version curr_version_date latest_version latest_version_date]

        HEADERS = {
          name: 'Gem',
          curr_version: 'Current',
          latest_version: 'Latest',
          latest_version_date: 'Latest Date'
        }

        CSV_HEADERS = {
          name: 'package',
          curr_version: 'curr_version',
          latest_version: 'latest_version',
          latest_version_date: 'latest_version_date'
        }

        def self.pretty(gems) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength
          return if gems.empty?

          # find the maximum length of each field across all the gems so we know how many
          # characters of horizontal space to allocate for each field when printing
          HEADERS.each do |key, val|
            instance_variable_set "@max_#{key}", val.length
            gems.each do |gem|
              curr_field_length = gem.send(key).length
              max_field_length = instance_variable_get "@max_#{key}"
              instance_variable_set "@max_#{key}", [curr_field_length, max_field_length].max
            end
          end

          line_length = HEADERS.sum { |key, _| instance_variable_get "@max_#{key}" } +
                        (COLUMN_GAP * (HEADERS.length - 1))

          puts '=' * line_length
          puts HEADERS.map { |key, val| val.ljust(instance_variable_get("@max_#{key}")) }.join(' ' * COLUMN_GAP)
          puts '=' * line_length

          gems.each do |gem|
            puts HEADERS.map { |key, _val|
                   gem.send(key).ljust(instance_variable_get("@max_#{key}"))
                 }.join(' ' * COLUMN_GAP)
          end
        end

        def self.csv(gems, fields: FIELDS, exclude_headers: false)
          return if gems.empty?

          puts fields.map { |field| CSV_HEADERS[field] }.join(',') unless exclude_headers

          gems.map { |gem| puts gem.to_csv(fields) }
        end
      end
    end
  end
end
