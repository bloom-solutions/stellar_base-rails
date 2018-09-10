require "spec_helper"

module StellarBase
  module WithdrawalRequests
    RSpec.describe FindWithdrawableAsset do
      it "returns hash of a withdrawable_asset" do
        details = described_class.("BTCT")
        expect(details[:type]).to eq "crypto"
        expect(details[:asset_code]).to eq "BTCT"
        expect(details[:fee_fixed]).to eq 0.01
      end
    end
  end
end
