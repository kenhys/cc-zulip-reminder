RSpec.describe "`zulip-reminder-cli add` command", type: :cli do
  it "executes `zulip-reminder-cli help add` command successfully" do
    output = `zulip-reminder-cli help add`
    expected_output = <<-OUT
Usage:
  zulip-reminder-cli add TIMESTAMP

Options:
  -h, [--help], [--no-help]  # Display usage information

Command description...
    OUT

    expect(output).to eq(expected_output)
  end
end
