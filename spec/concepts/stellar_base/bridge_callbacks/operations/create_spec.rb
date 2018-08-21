require "spec_helper"

module StellarBase
  module BridgeCallbacks
    module Operations
      RSpec.describe Create do

        it "processes a bridge server callback" do
          expect(BridgeCallbacks::Process).to receive(:call).and_return(true)

          op = described_class.({
            bridge_callback: {
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

          expect(op).to be_success

          callback = op["model"]
          expect(callback.operation_id).to eq "OPERATION_ID_1234"
          expect(callback.from).to eq "GABCSENDERXLMADDRESS"
          expect(callback.route).to eq "RECIPIENTROUTE"
          expect(callback.amount).to eq 100.00
          expect(callback.asset_code).to eq "XLM"
          expect(callback.asset_issuer).to eq "GABCASSETISSUER"
          expect(callback.memo_type).to eq "id"
          expect(callback.memo).to eq "2"
          expect(callback.data).to eq "DATAHASH"
          expect(callback.transaction_id).to eq "TRANSACTION_ID_1234"
        end

        context "operation id has been received before" do
          let!(:bridge_callback) do
            create(:stellar_base_bridge_callback, operation_id: "213")
          end

          it "is successful" do
            op = described_class.({
              bridge_callback: {
                id: "213",
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

            expect(op).to be_success
            expect(op["model"]).to eq bridge_callback
          end
        end

        context "module is not enabled" do
          before do
            StellarBase.configuration.modules = %i()
          end

          it "fails" do
            op = described_class.({
              bridge_callback: {
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

            expect(op).to_not be_success
            expect(BridgeCallback.exists?(operation_id: "OPERATION_ID_1234")).
              to be false
          end
        end

      end
    end
  end
end
