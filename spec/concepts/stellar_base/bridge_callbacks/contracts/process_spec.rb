require "spec_helper"

module StellarBase
  module BridgeCallbacks
    module Contracts
      describe Process do
        it "will validate and take in parameters" do
          contract = described_class.new(BridgeCallback.new)
          contract.validate({
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
          })

          expect(contract.id).to eq "OPERATION_ID_1234"
          expect(contract.from).to eq "GABCSENDERXLMADDRESS"
          expect(contract.route).to eq "RECIPIENTROUTE"
          expect(contract.amount).to eq 100.00
          expect(contract.asset_code).to eq "XLM"
          expect(contract.asset_issuer).to eq "GABCASSETISSUER"
          expect(contract.memo_type).to eq "id"
          expect(contract.memo).to eq "2"
          expect(contract.data).to eq "DATAHASH"
          expect(contract.transaction_id).to eq "TRANSACTION_ID_1234"

        end
      end
    end
  end
end
