require_relative './risk'
require_relative './risk_calculator'
require_relative './enum/risk_type'
require_relative './enum/risk_explanation'

module Package
  module Audit
    class Dependency
      attr_reader :name, :version
      attr_accessor :version_date, :latest_version, :latest_version_date, :vulnerability

      def initialize(name, version)
        @name = name.to_s
        @version = version.to_s
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

      def risk_type
        risk.type
      end

      def risk_explanation
        risk.explanation
      end

      def to_csv(fields)
        fields.map { |field| send(field) }.join(',')
      end
    end
  end
end
