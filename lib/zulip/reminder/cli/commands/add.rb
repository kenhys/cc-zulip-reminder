# frozen_string_literal: true

require 'zulip/client'
require_relative '../command'

module Zulip
  module Reminder
    module Cli
      module Commands
        class Add < Zulip::Reminder::Cli::Command
          def initialize(timestamp, options)
            @timestamp = timestamp
            @options = options
          end

          def execute(input: $stdin, output: $stdout)
            # Command logic goes here ...
            output.puts "OK"
          end
        end
      end
    end
  end
end
