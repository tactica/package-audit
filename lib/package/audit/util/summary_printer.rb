require_relative '../const'
require_relative './bash_color'

module Package
  module Audit
    module Util
      module SummaryPrinter
        def self.report
          printf("\n%<info>s\n%<cmd>s\n\n",
                 info: Util::BashColor.blue('To show how risk is calculated run:'),
                 cmd: Util::BashColor.magenta(' > bundle exec package-audit risk'))
        end

        def self.deprecated
          puts Util::BashColor.blue("\nAlthough gems listed above have no recent updates, they may not be deprecated.")
          puts Util::BashColor.blue("Please contact the gem author for more information about its status.\n")
        end

        def self.outdated
          printf("\n%<info>s\n%<cmd>s\n\n",
                 info: Util::BashColor.blue('To show both Gemfile gems and their dependencies run:'),
                 cmd: Util::BashColor.magenta(' > bundle exec package-audit outdated --include-implicit'))
        end

        def self.vulnerable
          printf("\n%<info>s\n%<cmd>s\n\n",
                 info: Util::BashColor.blue('To get more information about the vulnerabilities run:'),
                 cmd: Util::BashColor.magenta(' > bundle exec bundle-audit check --update'))
        end

        def self.total(num)
          puts Util::BashColor.cyan("\nFound a total of #{num} gems.")
        end

        def self.risk
          puts Util::BashColor.blue('1. Check if the dependency has a security vulnerability.')
          puts '   If yes, the following vulnerability -> risk mapping is used:'
          puts "      - #{Util::BashColor.red('unknown')} vulnerability\t-> #{Util::BashColor.red('high')} risk"
          puts "      - #{Util::BashColor.red('critical')} vulnerability\t-> #{Util::BashColor.red('high')} risk"
          puts "      - #{Util::BashColor.red('high')} vulnerability\t-> #{Util::BashColor.red('high')} risk"
          puts "      - #{Util::BashColor.orange('medium')} vulnerability\t-> #{Util::BashColor.orange('medium')} risk"
          puts "      - #{Util::BashColor.yellow('low')} vulnerability\t-> #{Util::BashColor.yellow('low')} risk"

          puts

          puts Util::BashColor.blue('2. Check the dependency for potential deprecation.')
          puts "   If no new releases by author for at least #{Const::YEARS_ELAPSED_TO_BE_OUTDATED} years:"
          puts "      - assign the risk to\t-> #{Util::BashColor.orange('medium')} risk"

          puts

          puts Util::BashColor.blue('3. Check if a newer version of the dependency is available.')

          puts '   If yes, assign risk as follows:'
          puts "      - #{Util::BashColor.orange('major version')} mismatch\t-> #{Util::BashColor.orange('medium')} risk"
          puts "      - #{Util::BashColor.yellow('minor version')} mismatch\t-> #{Util::BashColor.yellow('low')} risk"
          puts "      - #{Util::BashColor.green('patch version')} mismatch\t-> #{Util::BashColor.yellow('low')} risk"
          puts "      - #{Util::BashColor.green('build version')} mismatch\t-> #{Util::BashColor.yellow('low')} risk"

          puts

          puts Util::BashColor.blue('4. Take the highest risk from the first 3 steps.')
          puts '   If two risks match in severity, use the following precedence:'
          puts "      - #{Util::BashColor.red('vulnerability')} > #{Util::BashColor.orange('deprecation')} > #{Util::BashColor.yellow('outdatedness')}"

          puts

          puts Util::BashColor.blue('5. Check whether the dependency is used in production or not.')
          puts '   If a dependency is limited to a non-production environment:'
          puts "      - cap risk severity to\t -> #{Util::BashColor.orange('medium')} risk"
        end
      end
    end
  end
end
