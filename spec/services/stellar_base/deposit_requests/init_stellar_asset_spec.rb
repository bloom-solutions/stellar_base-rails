require "spec_helper"

module StellarBase
  module DepositRequests
    RSpec.describe InitStellarAsset do
      let(:issuing_account) { Stellar::Account.random }
      let(:deposit_request) do
        build_stubbed(:stellar_base_deposit_request, asset_code: "BTCT")
      end

      it "sets the stellar_asset in the context" do
        resulting_ctx = described_class.execute(
          issuer_account: issuing_account,
          deposit_request: deposit_request,
        )
        asset = resulting_ctx.stellar_asset

        expect(asset.code).to eq "BTCT"
        expect(asset.issuer).to eq issuing_account.keypair.public_key
      end
    end
  end
end
