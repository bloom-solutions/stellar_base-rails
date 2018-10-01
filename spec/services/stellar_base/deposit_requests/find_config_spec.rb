require "spec_helper"

module StellarBase
  module DepositRequests
    RSpec.describe FindConfig do
      context "config exists" do
        it "sets deposit_config on the context" do
          config = described_class.execute(network: "bitcoin").deposit_config
          expect(config[:network]).to eq "bitcoin"
          expect(config[:asset_code]).to eq "BTCT"
        end
      end

      context "config does not exist" do
        it "sets deposit_config to nil" do
          result = described_class.execute(network: "eth")
          expect(result).to be_failure
          expect(result.deposit_config).to be_nil
          expect(result.message).to eq "No depositable_asset config for eth"
        end
      end
    end
  end
end
