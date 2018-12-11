require "spec_helper"

module StellarBase
  module DepositRequests
    RSpec.describe Trigger do

      it "executes actions in order" do
        actions = [
          FindConfig,
          FindDepositRequest,
          CreateDeposit,
          InitAssetSendingClient,
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
          horizon_url: "horizon.com",
          sending_strategy: [:stellar_sdk],
        )

        actions.each do |action|
          expect(action).to receive(:execute).with(ctx).and_return(ctx)
        end

        described_class.("bitcoin", "btc-address", "1b3", 1.0, {
          horizon_url: "horizon.com",
          sending_strategy: [:stellar_sdk],
        })
      end
    end

    context "Stellar asset successfully sent" do
      let!(:deposit_request) do
        create(:stellar_base_deposit_request, {
          deposit_address: "btc-addr",
          account_id: ENV["SOURCE_ADDRESS"],
          issuer: ENV["ISSUER_ADDRESS"],
          asset_code: "BTCT",
          memo: "BB8",
        })
      end
      let(:client) { InitStellarClient.execute.stellar_sdk_client }

      it("exposes information about the Stellar transaction", {
        vcr: {record: :once},
      }) do
        result = Trigger.("bitcoin", "btc-addr", "3b1", 1.5)

        expect(result).to be_success
        expect(result).to_not be_failure

        deposit = result.deposit

        expect(deposit).to be_present
        expect(deposit.tx_id).to eq "3b1"
        expect(deposit.stellar_tx_id).to be_present
        expect(deposit.amount).to eq 1.5

        stellar_tx = client.horizon.transaction(hash: deposit.stellar_tx_id)
        expect(stellar_tx.memo).to eq "BB8"

        stellar_op = stellar_tx.operations.records.first
        expect(stellar_op.type).to eq "payment"
        expect(stellar_op.asset_code).to eq "BTCT"
        expect(stellar_op.asset_issuer).to eq ENV["ISSUER_ADDRESS"]
        expect(stellar_op.amount.to_f).to eq 1.5
      end
    end

    context "failure due to destination address not existing" do
      let!(:deposit_request) do
        create(:stellar_base_deposit_request, {
          deposit_address: "btc-addr",
          account_id: Stellar::Account.random.address,
          issuer: ENV["ISSUER_ADDRESS"],
          asset_code: "BTCT",
          memo: "BB8",
        })
      end

      it "exposes information about the failure", vcr: {record: :once} do
        result = Trigger.("bitcoin", "btc-addr", "3b1", 1.5)

        expect(result).to_not be_success
        expect(result).to be_failure
        expect(result.message).to include("Error sending the asset")
      end
    end

  end
end
