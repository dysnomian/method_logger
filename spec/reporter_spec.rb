require 'spec_helper'

describe Reporter do
  describe ".report" do
    before do
      ENV.store('COUNT_CALLS_TO', 'String#size')
      Reporter.instance_variable_set(:@call_count, 2)
    end

    let(:expected_output) { "String#size was called 2 times.\n" }

    it "outputs the expected string" do
      expect { Reporter.report }.to output(expected_output).to_stdout
    end
  end

  describe ".add_call" do
    before { Reporter.instance_variable_set(:@call_count, 0) }

    it "increments the count" do
      expect { Reporter.add_call }.to change { Reporter.call_count }.
        from(0).to(1)
    end
  end
end

