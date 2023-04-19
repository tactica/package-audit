module Package
  module Audit
    module Util
      module BashColor
        def self.green(str)
          "\e[32m#{str}\e[0m"
        end

        def self.yellow(str)
          "\e[33m#{str}\e[0m"
        end

        def self.orange(str)
          "\e[38;5;208m#{str}\e[0m"
        end

        def self.red(str)
          "\e[31m#{str}\e[0m"
        end
      end
    end
  end
end
