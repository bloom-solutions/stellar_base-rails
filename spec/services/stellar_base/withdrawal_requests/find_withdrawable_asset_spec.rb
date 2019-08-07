require "spec_helper"

module StellarBase
  module WithdrawalRequests
    RSpec.describe FindWithdrawableAsset do
      before do
        StellarBase.configuration.withdrawable_assets = [
          {
            type: "crypto",
            network: "bitcoin",
            asset_code: "BTCT",
            fee_fixed: 0.01,
          }
        ]
      end

      it "returns hash of a withdrawable_asset" do
        details = described_class.("BTCT")
        expect(details[:type]).to eq "crypto"
        expect(details[:asset_code]).to eq "BTCT"
        expect(details[:fee_fixed]).to eq 0.01
      end
    end
  end
end
