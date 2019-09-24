require 'zulip/reminder/cli/commands/list'

RSpec.describe Zulip::Reminder::Cli::Commands::List do
  it "executes `list` command successfully" do
    output = StringIO.new
    options = {}
    command = Zulip::Reminder::Cli::Commands::List.new(options)

    command.execute(output: output)

    expect(output.string).to eq("OK\n")
  end
end
