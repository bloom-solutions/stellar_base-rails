require "spec_helper"

module StellarBase
  module BridgeCallbacks
    module Contracts
      describe Create do
        let(:params) do
          {
            operation_id: "OPERATION_ID_1234",
            from: "GABCSENDERXLMADDRESS",
            route: "RECIPIENTROUTE",
            amount: 100.00,
            asset_code: "XLM",
            asset_issuer: "GABCASSETISSUER",
            memo_type: "id",
            memo: "2",
            data: "DATAHASH",
            transaction_id: "TRANSACTION_ID_1234",
          }
        end

        it "will validate and take in parameters" do
          contract = described_class.new(BridgeCallback.new)
          contract.validate(params)

          expect(contract.operation_id).to eq "OPERATION_ID_1234"
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

        context "no id was submitted" do
          it "returns errors" do
            contract = described_class.new(BridgeCallback.new)
            contract.validate({})

            expect(contract.errors[:operation_id]).to include "can't be blank"
          end
        end

        context "if check_bridge_callbacks_authenticity is true" do

          before do
            StellarBase.configure do |c|
              c.check_bridge_callbacks_authenticity = true
            end
          end

          after do
            StellarBase.configure do |c|
              c.check_bridge_callbacks_authenticity = false
            end
          end

          let(:check_params) do
            {
              operation_id: "OPERATION_ID_1234",
              transaction_id: "TRANSACTION_ID_1234",
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
            }
          end
          let(:result) { double(LightService::Context) }

          context "BridgeCallbacks::Check fails" do
            it "gives errors" do
              expect(BridgeCallbacks::Check).to receive(:call)
                .with(check_params)
                .and_return(result)

              expect(result).to receive(:failure?).and_return(true)
              expect(result).to receive(:message).and_return(
                "Operation #1234 doesn't exist"
              )

              contract = described_class.new(BridgeCallback.new)
              contract.validate(params)

              expect(contract.errors[:base])
                .to include "Operation #1234 doesn't exist"
            end
          end

          context "BridgeCallbacks::Check succeeds" do
            it "doesn't return any error" do
              expect(BridgeCallbacks::Check).to receive(:call)
                .with(check_params)
                .and_return(result)

              expect(result).to receive(:failure?).and_return(false)

              contract = described_class.new(BridgeCallback.new)
              contract.validate(params)

              expect(contract.errors[:base]).to be_empty
            end

          end
        end
      end
    end
  end
end
