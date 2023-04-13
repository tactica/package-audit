module Package
  module Audit
    module Ruby
      class GemData
        attr_reader :name, :curr_version, :curr_version_date, :latest_version, :latest_version_date

        def initialize(name:, curr_version:, curr_version_date:, latest_version:, latest_version_date:)
          @name = name.to_s
          @curr_version = curr_version.to_s
          @curr_version_date = curr_version_date.strftime('%Y-%m-%d')
          @latest_version = latest_version
          @latest_version_date = latest_version_date.strftime('%Y-%m-%d')
        end

        def to_csv(fields)
          fields.map { |field| send(field) }.join(',')
        end
      end
    end
  end
end
