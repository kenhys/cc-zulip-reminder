# frozen_string_literal: true

require 'zulip/reminder/config'
require 'zulip/client'
require_relative '../command'

module Zulip
  module Reminder
    module Cli
      module Commands
        class Delete < Zulip::Reminder::Cli::Command
          def initialize(type, options)
            @type = type
            @options = options
            @config = Zulip::Reminder::Config.new
          end

          def execute(input: $stdin, output: $stdout)
            path = @config.task_path
            unless path.exist?
              puts "No registered jobs"
              return
            end
            data = YAML.load_file(path.to_s)
            job_id = nil
            case @type
            when "first"
              job_id = data.keys.first
            when "last"
              job_id = data.keys.last
            else
              if @type.to_i != 0
                job_id = @type.to_i
              else
                job_id = data.keys.first
              end
            end

            unless job_id.nil?
              puts "No registered jobs"
              return
            end

            content = "#{@config.bot} delete job #{job_id}"
            puts "Delete: #{content}"
            client = Zulip::Client.new(site: @config.site,
                                       username: @config.email,
                                       api_key: @config.key)
            client.send_message(type: :stream, to: @config.stream, subject: @config.topic, content: content)
            data.delete(job_id)
            open(path.to_s, "w+") do |file|
              file.puts(YAML.dump(data))
            end
          end
        end
      end
    end
  end
end
