require "spec_helper"

module StellarBase
  module BridgeCallbacks
    RSpec.describe self::Process do
      let(:callback) { BridgeCallback.new }

      context ".bridge_on_receive is a string" do
        before do
          StellarBase.configuration.on_bridge_callback =
            ProcessBridgeCallback.to_s
        end

        it "triggers that callback class" do
          expect(ProcessBridgeCallback).to receive(:call)
            .with(callback).and_return(true)

          described_class.(callback)
        end
      end

      context ".bridge_on_receive is a class" do
        before do
          StellarBase.configuration.on_bridge_callback = ProcessBridgeCallback
        end

        it "triggers that callback class" do
          expect(ProcessBridgeCallback).to receive(:call)
            .with(callback).and_return(true)

          described_class.(callback)
        end
      end

      context ".bridge_on_receive is a proc" do
        before do
          @bridge_callback = nil
          StellarBase.configuration.on_bridge_callback = ->(bridge_callback) do
            @bridge_callback = bridge_callback
          end
        end

        it "triggers that callback class" do
          described_class.(callback)
          expect(@bridge_callback).to eq callback
        end
      end

      context ".bridge_on_receive is not configured" do
        before do
          StellarBase.configure do |c|
            c.on_bridge_callback = ""
          end
        end

        after do
          StellarBase.configure do |c|
            c.on_bridge_callback = "ProcessBridgeCallback"
          end
        end

        it "raises an exception" do
          error_message = [
            "StellarBase.on_bridge_callback isn't configured or the",
            "configured callback class doesn't exist: ",
          ].join(" ")

          expect { described_class.(callback) }
            .to raise_error(NameError, error_message)
        end

      end
    end
  end
end
