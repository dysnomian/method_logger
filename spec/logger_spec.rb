require 'spec_helper'

describe Logger do
  describe "#__add_logger" do
    let(:klass) do
      Class.new do
        extend Logger

        def some_method
          :value
        end
        __add_logger(:some_method)

        def another_method
          :wrong
        end
      end
    end

    it "replaces the method with a traced one" do
      allow(Reporter).to receive(:add_call)
      klass.new.some_method
      expect(Reporter).to have_received(:add_call).once
    end

    it "still returns the result of the original" do
      expect(klass.new.some_method).to eq(:value)
    end

    it "leaves other methods alone" do
      allow(Reporter).to receive(:add_call)
      klass.new.another_method
      expect(Reporter).not_to have_received(:add_call)
    end
  end
end
