require 'zulip/reminder/cli/commands/add'

RSpec.describe Zulip::Reminder::Cli::Commands::Add do
  it "executes `add` command successfully" do
    output = StringIO.new
    timestamp = nil
    options = {}
    command = Zulip::Reminder::Cli::Commands::Add.new(timestamp, options)

    command.execute(output: output)

    expect(output.string).to eq("OK\n")
  end
end
