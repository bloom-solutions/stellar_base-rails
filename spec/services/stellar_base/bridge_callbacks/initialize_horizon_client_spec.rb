require "spec_helper"

module StellarBase
  module BridgeCallbacks
    describe InitializeHorizonClient do
      it "returns a HorizonClient instance" do
        result = described_class.execute
        expect(result.client).to be_a StellarBase::HorizonClient
      end
    end
  end
end
