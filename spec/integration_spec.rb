require 'spec_helper'
require 'method_logger'

def test_with_method(method_name)
  ENV.store('COUNT_CALLS_TO', method_name)
  Clobberer.run
end

describe "Integration" do
  describe "with inherited instance methods" do
    before { test_with_method("String#size") }

    let(:method_call) do
      (1..100).each { |i| i.to_s.size if i.odd? }
    end

    pending "counts calls successfully when ENV variable is set" do
      expect { Reporter.report }.to output("String#size called 50 times").to_stdout
    end
  end

  describe "with included instance methods" do
    before { method_call
             test_with_method("B#foo") }

    let(:method_call) do
      module A
        def foo
        end
      end

      class B
        include A
      end

      10.times { B.new.foo }
    end

    pending "counts calls successfully when ENV variable is set" do
      expect { method_call }.to output("B#foo called 10 times").to_stdout
    end
  end

  describe "with an instance method" do
    before { klass; test_with_method('Klass#some_method') }

    context "when public" do
      let(:klass) do
        class Klass
          def some_method
          end
        end
        Klass
      end

      let(:instance)    { klass.new }
      let(:method_call) { 10.times { instance.some_method } }

      it "counts calls successfully when ENV variable is set" do
        puts instance.some_method
        expect { method_call }.to output("Klass#some_method called 10 times").
          to_stdout
      end
    end

    context "when private" do
      let(:klass)       { Class.new { private def some_method; end } }
      let(:instance)    { klass.new }
      let(:method_call) { 10.times { instance.send(:some_method) } }

      it "counts calls successfully when ENV variable is set" do
        expect { method_call }.to change { Reporter.call_count }.from(0).to(10)
      end

      it "outputs calls successfully when ENV variable is set" do
        expect { method_call }.to output("Klass#some_method called 10 times").
          to_stdout
      end
    end
  end

  describe "with a class method" do
    before { test_with_method("Klass.some_method") }

    context "when public" do
      let(:method_call) do
        class Klass
          def self.some_method
          end
        end

        10.times { Klass.some_method }
      end

      pending "counts calls successfully when ENV variable is set" do
        expect { method_call }.to output("Klass.some_method called 10 times").to_stdout
      end
    end

    context "when private" do

      let(:method_call) do
        class Klass
          private
          def self.some_method
          end
        end

        10.times { Klass.send(:some_method) }
      end

      pending "counts calls successfully when ENV variable is set" do
        expect { method_call }.to output("Klass.some_method called 10 times").to_stdout
      end
    end
  end
end
