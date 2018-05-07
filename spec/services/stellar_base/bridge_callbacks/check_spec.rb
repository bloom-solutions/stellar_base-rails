require "spec_helper"

module StellarBase
  module BridgeCallbacks
    RSpec.describe Check do
      it "calls a series of actions" do
        actions = [
          InitializeHorizonClient,
          GetOperation,
          GetTransaction,
          Compare,
        ]

        ctx = LightService::Context.new(
          operation_id: "1234",
          transaction_id: "1234",
          params: {
            id: "OPERATION_ID_1234",
            from: "GABCSENDERXLMADDRESS",
            route: "RECIPIENTROUTE",
            amount: 100.00,
            asset_code: "XLM",
            asset_issuer: "GABCASSETISSUER",
            memo_type: "id",
            memo: "2",
            data: "DATAHASH",
            transaction_id: "TRANSACTION_ID_1234",
          },
        )

        actions.each do |action|
          expect(action).to receive(:execute).with(ctx).and_return(ctx)
        end

        described_class.({
          operation_id: "1234",
          transaction_id: "1234",
          params: {
            id: "OPERATION_ID_1234",
            from: "GABCSENDERXLMADDRESS",
            route: "RECIPIENTROUTE",
            amount: 100.00,
            asset_code: "XLM",
            asset_issuer: "GABCASSETISSUER",
            memo_type: "id",
            memo: "2",
            data: "DATAHASH",
            transaction_id: "TRANSACTION_ID_1234",
          },
        })
      end
    end
  end
end
