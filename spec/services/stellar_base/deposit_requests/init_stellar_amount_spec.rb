require "spec_helper"

module StellarBase
  module DepositRequests
    RSpec.describe InitStellarAmount do
      let(:stellar_issuer) { Stellar::Account.random }
      let(:stellar_asset) do
        Stellar::Asset.alphanum4("BTC", stellar_issuer.keypair)
      end

      it "sets the stellar_amount in the context" do
        resulting_ctx = described_class.execute(
          stellar_asset: stellar_asset,
          amount: 1.5,
        )
        amount = resulting_ctx.stellar_amount

        expect(amount.amount).to eq 1.5
        expect(amount.asset).to eq stellar_asset
      end
    end
  end
end
