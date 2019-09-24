# coding: utf-8
require 'pathname'
require 'yaml'
require 'fileutils'

module Zulip
  module Reminder
    class Config

      attr_reader :email
      attr_reader :key
      attr_reader :site
      attr_reader :stream
      attr_reader :topic
      attr_reader :bot
      attr_reader :user

      def initialize
        parse_zuliprc
        parse_config
      end

      def task_path
        Pathname("~/.config/zulip-reminder/task.yaml").expand_path
      end

      private
      def parse_zuliprc
        open(File.expand_path("~/.zuliprc")) do |file|
          file.each_line do |line|
            case line
            when /email=(.*)/
              @email = $1
            when /key=(.*)/
              @key = $1
            when /site=(.*)/
              @site = $1
            end
          end
        end
      end

      def parse_config
        conf_dir = FileUtils.mkdir_p(Pathname("~/.config/zulip-reminder").expand_path)
        path = File.join(conf_dir, "zulip.conf")
        yaml = YAML.load_file(path)
        @stream = yaml["stream"]
        @bot = yaml["bot"]
        @topic = yaml["topic"]
        @user = yaml["user"]
      end
    end
  end
end
