RSpec.describe "`zulip-reminder-cli list` command", type: :cli do
  it "executes `zulip-reminder-cli help list` command successfully" do
    output = `zulip-reminder-cli help list`
    expected_output = <<-OUT
Usage:
  zulip-reminder-cli list

Options:
  -h, [--help], [--no-help]  # Display usage information

Command description...
    OUT

    expect(output).to eq(expected_output)
  end
end
