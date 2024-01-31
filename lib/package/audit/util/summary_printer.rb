require_relative '../const/time'
require_relative 'bash_color'

module Package
  module Audit
    module Util
      module SummaryPrinter
        def self.all
          printf("\n%<info>s\n%<cmd>s\n\n",
                 info: Util::BashColor.blue('To show how risk is calculated run:'),
                 cmd: Util::BashColor.magenta(' > package-audit risk'))
        end

        def self.deprecated
          puts Util::BashColor.blue('Although the packages above have no recent updates, they may not be deprecated.')
          puts Util::BashColor.blue("Please contact the package author for more information about its status.\n")
        end

        def self.vulnerable(technology, cmd)
          printf("%<info>s\n%<cmd>s\n\n",
                 info: Util::BashColor.blue("To get more information about the #{technology} vulnerabilities run:"),
                 cmd: Util::BashColor.magenta(" > #{cmd}"))
        end

        def self.total(technology, report, pkgs)
          if pkgs.any?
            puts Util::BashColor.cyan("Found a total of #{pkgs.length} #{technology} packages.\n")
          else
            puts Util::BashColor.green("There are no #{report} #{technology} packages!\n")
          end
        end

        def self.statistics(technology, report, pkgs, ignored_pkgs)
          stats = calculate_statistics(pkgs, ignored_pkgs)
          display_results(technology, report, pkgs, ignored_pkgs, stats)
        end

        class << self
          private

          def calculate_statistics(pkgs, ignored_pkgs)
            stats = {
              outdated: count_status(pkgs, :outdated?),
              deprecated: count_status(pkgs, :deprecated?),
              vulnerable: count_status(pkgs, :vulnerable?),
              outdated_ignored: count_status(ignored_pkgs, :outdated?),
              deprecated_ignored: count_status(ignored_pkgs, :deprecated?),
              vulnerable_ignored: count_status(ignored_pkgs, :vulnerable?)
            }

            stats[:vulnerabilities] = pkgs.sum { |pkg| pkg.vulnerabilities.length }
            stats
          end

          def count_status(pkgs, status)
            pkgs.count(&status)
          end

          def display_results(technology, report, pkgs, ignored_pkgs, stats)
            if pkgs.any?
              puts status_message(stats)
              total(technology, report, pkgs)
            elsif ignored_pkgs.any?
              puts Util::BashColor.green("There are no deprecated, outdated or vulnerable #{technology}  " \
                                         "packages (#{ignored_pkgs} ignored)!\n")
            else
              puts Util::BashColor.green("There are no deprecated, outdated or vulnerable #{technology} packages!\n")
            end
          end

          def status_message(stats)
            outdated_str = "#{stats[:outdated]} outdated" + outdated_details(stats)
            deprecated_str = "#{stats[:deprecated]} deprecated" + deprecated_details(stats)
            vulnerable_str = "#{stats[:vulnerable]} vulnerable" + vulnerability_details(stats)

            Util::BashColor.cyan("#{vulnerable_str}, #{outdated_str}, #{deprecated_str}.")
          end

          def outdated_details(stats)
            return '' if (stats[:outdated_ignored] + stats[:outdated]).zero?

            details = []
            details << "#{stats[:outdated_ignored]} ignored" if stats[:outdated_ignored].positive?
            " (#{details.join(', ')})"
          end

          def deprecated_details(stats)
            return '' if (stats[:deprecated_ignored] + stats[:deprecated]).zero?

            details = []
            details << "#{stats[:deprecated_ignored]} ignored" if stats[:deprecated_ignored].positive?
            " (#{details.join(', ')})"
          end

          def vulnerability_details(stats)
            return '' if (stats[:vulnerable_ignored] + stats[:vulnerabilities]).zero?

            details = []
            details << "#{stats[:vulnerabilities]} vulnerabilities" if stats[:vulnerabilities].positive?
            details << "#{stats[:vulnerable_ignored]} ignored" if stats[:vulnerable_ignored].positive?
            " (#{details.join(', ')})"
          end
        end
      end
    end
  end
end
