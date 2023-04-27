require_relative './risk'
require_relative './risk_calculator'
require_relative './enum/environment'
require_relative './enum/risk_type'
require_relative './enum/risk_explanation'

module Package
  module Audit
    class Package
      attr_reader :name, :version
      attr_accessor :groups, :version_date, :latest_version, :latest_version_date, :vulnerabilities

      def initialize(name, version, **attr)
        @name = name.to_s
        @version = version.to_s
        @groups = []
        @vulnerabilities = []
        update(**attr)
      end

      def full_name
        "#{name}@#{version}"
      end

      def update(**attr)
        attr.each { |key, value| instance_variable_set("@#{key}", value) }
      end

      def risk
        @risk ||= RiskCalculator.new(self).find || Risk.new(Enum::RiskType::NONE)
      end

      def risk?
        risk.type != Enum::RiskType::NONE
      end

      def group_list
        @groups.join('|')
      end

      def vulnerabilities_grouped
        @vulnerabilities.group_by(&:itself).map { |k, v| "#{k}(#{v.length})" }.join('|')
      end

      def risk_type
        risk.type
      end

      def risk_explanation
        risk.explanation
      end

      def to_csv(fields)
        fields.map { |field| send(field) }.join(',')
      end

      def to_s
        "#{@name} #{@version} - [#{@groups.sort.join(', ')}]"
      end
    end
  end
end
