# frozen_string_literal: true

require 'thor'

module Zulip
  module Reminder
    module Cli
      # Handle the application command line parsing
      # and the dispatch to various command objects
      #
      # @api public
      class CLI < Thor
        # Error raised by this runner
        Error = Class.new(StandardError)

        desc 'version', 'zulip-reminder-cli version'
        def version
          require_relative 'version'
          puts "v#{Zulip::Reminder::Cli::VERSION}"
        end
        map %w(--version -v) => :version

        desc 'add TIMESTAMP', 'Command description...'
        method_option :help, aliases: '-h', type: :boolean,
                             desc: 'Display usage information'
        def add(timestamp, message)
          if options[:help]
            invoke :help, ['add']
          else
            require_relative 'commands/add'
            Zulip::Reminder::Cli::Commands::Add.new(timestamp, message, options).execute
          end
        end
      end
    end
  end
end
