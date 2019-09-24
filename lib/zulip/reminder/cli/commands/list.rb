# frozen_string_literal: true

require 'zulip/reminder/config'
require 'tty/table'
require_relative '../command'

module Zulip
  module Reminder
    module Cli
      module Commands
        class List < Zulip::Reminder::Cli::Command
          def initialize(options)
            @options = options
            @config = Zulip::Reminder::Config.new
          end

          def execute(input: $stdin, output: $stdout)
            path = @config.task_path
            raw_data = {}
            if path.exist?
              raw_data = YAML.load_file(path.to_s)
            end
            data = []
            raw_data.each do |job_id,line|
              bot = @config.bot.gsub('*', '')
              user = @config.user.gsub('*', '')
              task = ""
              line.match(/echo #{user} (.+)$/) do |matched|
                task = matched[1]
              end
              data << [job_id, task]
            end
            table = ::TTY::Table.new ['job id', 'task'], data
            renderer = TTY::Table::Renderer::Unicode.new(table)
            puts table.render(:unicode)
          end
        end
      end
    end
  end
end
