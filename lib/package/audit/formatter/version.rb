require_relative './base'
require_relative '../util/bash_color'

module Package
  module Audit
    module Formatter
      class Version < Formatter::Base
        def initialize(curr, target)
          super()
          @curr = curr
          @target = target
        end

        def format # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
          curr_tokens = @curr.split('.')
          target_tokens = @target.split('.')

          if curr_tokens[0] && curr_tokens[0] < target_tokens[0]
            Util::BashColor.orange(@curr)
          elsif curr_tokens[1] && curr_tokens[1] < target_tokens[1]
            "#{curr_tokens[0]}.#{Util::BashColor.yellow(curr_tokens[1..]&.join('.'))}"
          elsif curr_tokens[2] && curr_tokens[2] < target_tokens[2]
            "#{curr_tokens[0..1]&.join('.')}.#{Util::BashColor.green(curr_tokens[2..]&.join('.'))}"
          elsif curr_tokens[3] && curr_tokens[3] < target_tokens[3]
            "#{curr_tokens[0..2]&.join('.')}.#{Util::BashColor.green(curr_tokens[3])}"
          else
            @curr
          end
        end
      end
    end
  end
end