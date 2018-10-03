require "spec_helper"

module StellarBase
  module DepositRequests
    RSpec.describe Trigger do
      it "executes actions in order" do
        actions = [
          FindConfig,
          FindDepositRequest,
          FindDeposit,
          CreateDeposit,
          InitStellarClient,
          InitStellarIssuerAccount,
          InitStellarRecipientAccount,
          InitStellarDistributionAccount,
          InitStellarAsset,
          InitStellarAmount,
          SendAsset,
          UpdateDeposit,
        ]

        ctx = LightService::Context.new(
          network: "bitcoin",
          deposit_address: "btc-address",
          tx_id: "1b3",
          amount: 1.0,
        )

        actions.each do |action|
          expect(action).to receive(:execute).with(ctx).and_return(ctx)
        end

        described_class.("bitcoin", "btc-address", "1b3", 1.0)
      end
    end
  end
end
