module Package
  module Audit
    class DuplicatePackageMerger
      def initialize(pkgs)
        @pkgs = pkgs.sort_by(&:full_name)
      end

      def run # rubocop:disable Metrics/AbcSize
        pkgs = @pkgs.take(1)

        @pkgs[1..]&.each do |curr|
          prev = pkgs[-1]
          if curr.full_name == prev.full_name
            prev.update(groups: prev.groups | curr.groups,
                        vulnerabilities: prev.vulnerabilities + curr.vulnerabilities,
                        risks: prev.risks + curr.risks)
          else
            pkgs << curr
          end
        end

        pkgs
      end
    end
  end
end
