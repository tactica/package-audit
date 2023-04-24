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
      end
    end
  end
end
