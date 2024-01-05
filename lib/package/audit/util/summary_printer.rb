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

        def self.total(technology, report, pkgs, ignored_pkgs)
          if ignored_pkgs.any?
            puts Util::BashColor.cyan("Found a total of #{pkgs.length} #{technology} packages " \
                                      "(#{ignored_pkgs.length} ignored).\n")
          elsif pkgs.any?
            puts Util::BashColor.cyan("Found a total of #{pkgs.length} #{technology} packages.\n")
          else
            puts Util::BashColor.green("There are no #{report} #{technology} packages!\n")
          end
        end

        def self.statistics(technology, report, pkgs, ignored_pkgs) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
          outdated = pkgs.count(&:outdated?)
          deprecated = pkgs.count(&:deprecated?)
          vulnerable = pkgs.count(&:vulnerable?)

          vulnerabilities = pkgs.sum { |pkg| pkg.vulnerabilities.length }

          if pkgs.any?
            puts Util::BashColor.cyan("#{vulnerable} vulnerable (#{vulnerabilities} vulnerabilities), " \
                                      "#{outdated} outdated, #{deprecated} deprecated.")
            total(technology, report, pkgs, ignored_pkgs)
          elsif ignored_pkgs.any?
            puts Util::BashColor.green("There are no deprecated, outdated or vulnerable #{technology} " \
                                       "packages (#{ignored_pkgs.length} ignored)!\n")
          else
            puts Util::BashColor.green("There are no deprecated, outdated or vulnerable #{technology} packages!\n")
          end
        end

        def self.risk # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
          puts Util::BashColor.blue('1. Check if the package has a security vulnerability.')
          puts '   If yes, the following vulnerability -> risk mapping is used:'
          puts "      - #{Util::BashColor.red('unknown')} vulnerability\t-> #{Util::BashColor.red('high')} risk"
          puts "      - #{Util::BashColor.red('critical')} vulnerability\t-> #{Util::BashColor.red('high')} risk"
          puts "      - #{Util::BashColor.red('high')} vulnerability\t-> #{Util::BashColor.red('high')} risk"
          puts "      - #{Util::BashColor.orange('medium')} vulnerability\t-> #{Util::BashColor.orange('medium')} risk"
          puts "      - #{Util::BashColor.orange('moderate')} vulnerability\t-> #{Util::BashColor.orange('medium')} risk" # rubocop:disable Layout/LineLength
          puts "      - #{Util::BashColor.yellow('low')} vulnerability\t-> #{Util::BashColor.yellow('low')} risk"

          puts

          puts Util::BashColor.blue('2. Check the package for potential deprecation.')
          puts "   If no new releases by author for at least #{Const::Time::YEARS_ELAPSED_TO_BE_OUTDATED} years:"
          puts "      - assign the risk to\t-> #{Util::BashColor.orange('medium')} risk"

          puts

          puts Util::BashColor.blue('3. Check if a newer version of the package is available.')

          puts '   If yes, assign risk as follows:'
          puts "      - #{Util::BashColor.orange('major version')} mismatch\t-> #{Util::BashColor.orange('medium')} risk" # rubocop:disable Layout/LineLength
          puts "      - #{Util::BashColor.yellow('minor version')} mismatch\t-> #{Util::BashColor.yellow('low')} risk"
          puts "      - #{Util::BashColor.green('patch version')} mismatch\t-> #{Util::BashColor.yellow('low')} risk"
          puts "      - #{Util::BashColor.green('build version')} mismatch\t-> #{Util::BashColor.yellow('low')} risk"

          puts

          puts Util::BashColor.blue('4. Take the highest risk from the first 3 steps.')
          puts '   If two risks match in severity, use the following precedence:'
          puts "      - #{Util::BashColor.red('vulnerability')} > #{Util::BashColor.orange('deprecation')} > #{Util::BashColor.yellow('outdatedness')}" # rubocop:disable Layout/LineLength

          puts

          puts Util::BashColor.blue('5. Check whether the package is used in production or not.')
          puts '   If a package is limited to a non-production group:'
          puts "      - cap risk severity to\t -> #{Util::BashColor.yellow('low')} risk"
        end
      end
    end
  end
end
