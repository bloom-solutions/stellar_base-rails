require "spec_helper"

module StellarBase
  module DepositRequests
    RSpec.describe FindDepositableAsset do
      it "returns hash of a depositable_assets" do
        details = described_class.("BTCT")
        expect(details[:type]).to eq "crypto"
        expect(details[:asset_code]).to eq "BTCT"
        expect(details[:network]).to eq "bitcoin"
      end
    end
  end
end
