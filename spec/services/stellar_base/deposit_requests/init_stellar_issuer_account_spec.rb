require "spec_helper"

module StellarBase
  module DepositRequests
    RSpec.describe InitStellarIssuerAccount do
      let(:deposit_config) do
        FindConfig.execute(network: "bitcoin").deposit_config
      end

      it "sets the stellar_issuer_account in the context" do
        resulting_ctx = described_class.execute(deposit_config: deposit_config)
        account = resulting_ctx.issuer_account

        expect(account).to be_a Stellar::Account
        expect(account.address).to eq deposit_config[:issuer]
      end
    end
  end
end
