require 'zulip/reminder/cli/commands/delete'

RSpec.describe Zulip::Reminder::Cli::Commands::Delete do
  it "executes `delete` command successfully" do
    output = StringIO.new
    type = nil
    options = {}
    command = Zulip::Reminder::Cli::Commands::Delete.new(type, options)

    command.execute(output: output)

    expect(output.string).to eq("OK\n")
  end
end
