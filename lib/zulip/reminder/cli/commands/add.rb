# frozen_string_literal: true

require 'net/http'
require 'time'
require 'zulip/reminder/config'
require 'zulip/client'
require_relative '../command'

module Zulip
  module Reminder
    module Cli
      module Commands
        class Add < Zulip::Reminder::Cli::Command
          def initialize(timestamp, message, options)
            @timestamp = timestamp
            @message = message
            @options = options
            @config = Zulip::Reminder::Config.new
          end

          def execute(input: $stdin, output: $stdout)
            client = Zulip::Client.new(site: @config.site,
                                       username: @config.email,
                                       api_key: @config.key)
            content = "#{@config.bot} add job \"#{convert_timestamp(@timestamp)}\" #{@config.bot} echo #{@config.user} #{@message}"
            puts "Register: #{content}"
            client.send_message(type: :stream, to: @config.stream, subject: @config.topic, content: content)
            result = fetch_bot_response
            task = ""
            job_id = ""
            result["messages"].each do |message|
              content = message["content"].gsub(/(<[^>]*>)/) {""}
              puts "Check: #{content}"
              case  message["sender_email"]
              when @config.email
                task = content
                puts "Fetched task: #{task}"
              else
                content.match(/^Job (.+) created/) do |matched|
                  job_id = matched[1]
                  puts "Fetched job id: #{job_id}"
                end
              end
            end

            if job_id.empty?
              puts "Failed to confirm job"
              return
            end

            if task.empty?
              puts "Failed to confirm task"
              return
            end

            path = @config.task_path
            data = {}
            if path.exist?
              data = YAML.load_file(path.to_s)
            end
            data[job_id] = task
            open(path.to_s, "w+") do |file|
              file.puts(YAML.dump(data))
            end
          end

          private
          def fetch_bot_response
            params = {}
            params["use_first_unread_anchor"] = true
            params["num_before"] = 2
            params["num_after"] = 1
            narrow = [
              {"operand": @config.stream, "operator":"stream"},
              {"operand": @config.topic, "operator":"topic"}
            ]
            params["narrow"] = JSON.generate(narrow)
            data = URI.encode_www_form(params)
            uri = URI("#{@config.site}/api/v1/messages?" + data)
            result = nil
            Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
              request = Net::HTTP::Get.new(uri)
              request.basic_auth(@config.email, @config.key)
              response = http.request(request)
              result = JSON.parse(response.body)
            end
            result
          end

          def convert_timestamp(content)
            t = Time.parse(`LANG=C date -d "#{content}"`)
            "#{t.min} #{t.hour} #{t.day} #{t.month} *"
          end
        end
      end
    end
  end
end
