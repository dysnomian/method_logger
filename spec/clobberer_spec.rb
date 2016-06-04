require 'spec_helper'

describe Clobberer do
    before(:all) do
      ENV.store('COUNT_CALLS_TO', 'TestClass#some_method')

      class TestClass
        def some_method; :value; end
      end

      Clobberer.run
    end

  describe ".run" do
    it "preserves execution" do
      expect(TestClass.new.some_method).to eq(:value)
    end

    it "replaces the method in COUNT_CALLS_TO" do
      allow(Reporter).to receive(:add_call)
      TestClass.new.some_method
      expect(Reporter).to have_received(:add_call).once
    end
  end
end
