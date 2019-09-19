RSpec.describe "`zulip-reminder-cli delete` command", type: :cli do
  it "executes `zulip-reminder-cli help delete` command successfully" do
    output = `zulip-reminder-cli help delete`
    expected_output = <<-OUT
Usage:
  zulip-reminder-cli delete [TYPE]

Options:
  -h, [--help], [--no-help]  # Display usage information

Command description...
    OUT

    expect(output).to eq(expected_output)
  end
end
