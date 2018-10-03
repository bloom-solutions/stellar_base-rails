require "spec_helper"

module StellarBase
  module DepositRequests
    RSpec.describe InitStellarDistributionAccount do
      let(:distribution_account) { Stellar::Account.random }
      let(:deposit_config) do
        FindConfig.execute(network: "bitcoin").deposit_config
      end

      it "sets the stellar_asset in the context" do
        resulting_ctx = described_class.execute(deposit_config: deposit_config)
        account = resulting_ctx.distribution_account

        expect(account.address).to eq deposit_config[:distributor]
        expect(account.keypair.seed).to eq deposit_config[:distributor_seed]
      end
    end
  end
end
