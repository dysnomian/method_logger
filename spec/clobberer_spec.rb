require 'spec_helper'

describe Clobberer do
  describe ".run" do
    context "with an instance method" do
      before(:all) do
        ENV.store('COUNT_CALLS_TO', 'TestClass#some_method')

        class TestClass
          def some_method; :value; end
        end

        Clobberer.run
      end

      it "preserves execution" do
        expect(TestClass.new.some_method).to eq(:value)
      end

      it "replaces the method in COUNT_CALLS_TO" do
        allow(Reporter).to receive(:add_call)
        TestClass.new.some_method
        expect(Reporter).to have_received(:add_call).once
      end
    end

    context "with a class method" do
      before(:all) do
        ENV.store('COUNT_CALLS_TO', 'TestClass.some_method')

        class TestClass
          def self.some_method; :value; end
        end

        Clobberer.run
      end

      it "preserves execution" do
        expect(TestClass.some_method).to eq(:value)
      end

      it "has no instance methods" do
        expect(TestClass.new.methods(false)).to eq([])
      end
      it "has new class methods" do
        expect(TestClass.instance_methods(false)).to eq([])
      end

      it "replaces the method in COUNT_CALLS_TO" do
        allow(Reporter).to receive(:add_call)
        TestClass.some_method
        expect(Reporter).to have_received(:add_call).once
      end
    end
  end
end
