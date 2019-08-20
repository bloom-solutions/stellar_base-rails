require "spec_helper"

module StellarBase
  module DepositRequests
    module Operations
      RSpec.describe Create do
        context "valid parameters" do
          let(:asset_details) do
            FindAssetDetails.(operation: "deposit", asset_code: "BTCT")
          end
          let(:params) do
            {
              asset_code: "BTCT",
              account: "G-STELLAR-ACCOUNT",
              account_id: "G-STELLAR-ACCOUNT",
              deposit_type: nil,
              memo: "MEMO",
              memo_type: "text",
              extra_info: {extra: "info"}.to_json,
            }
          end
          it "succeeds and creates DepositRequest" do
            expect(GenMemoFor).to receive(:call).with(DepositRequest)
              .and_return("MEMO")
            expect(ConfiguredClassRunner).to receive(:call)
              .with(GetMaxAmount).and_return(100)
            expect(DetermineEta).to receive(:call)
              .with(GetEta, params)
              .and_return(600)
            expect(DetermineHow).to receive(:call)
              .with(GetHow, params)
              .and_return("BTCADDR")
            expect(DetermineExtraInfo).to receive(:call).
              with(asset_details).
              and_return({extra: "info"})

            op = described_class.(deposit_request: {
              asset_code: "BTCT",
              account: "G-STELLAR-ACCOUNT",
            })

            expect(op).to be_success
            deposit = op["model"]

            expect(deposit).to be_persisted
            expect(deposit.asset_type).to eq "crypto"
            expect(deposit.asset_code).to eq "BTCT"
            expect(deposit.account_id).to eq "G-STELLAR-ACCOUNT"
            expect(deposit.deposit_address)
              .to eq "BTCADDR"
            expect(deposit.eta).to be_an Integer
            expect(deposit.issuer).to eq ENV["ISSUER_ADDRESS"]
            expect(deposit.memo_type).to eq "text"
            expect(deposit.memo).to eq "MEMO"
            expect(deposit.eta).to eq 600
            expect(deposit.min_amount).to be_a BigDecimal
            expect(deposit.max_amount).to eq 100
            expect(deposit.fee_fixed).to be_zero
            expect(deposit.fee_percent).to be_zero
            expect(JSON.parse(deposit.extra_info)["extra"]).
              to eq "info"
          end
        end

        context "module is not configured" do
          before do
            StellarBase.configuration.modules = %i[]
          end

          it "fails the policy" do
            op = described_class.(deposit_request: {
              asset_code: "BTCT",
              account: "G-STELLAR-ACCOUNT",
            })

            expect(op).to_not be_success
            expect(op["result.policy.default"]).not_to be_success
          end
        end

        context "invalid parameters" do
          it "fails" do
            expect(GenMemoFor).to receive(:call).with(DepositRequest)
              .and_return("MEMO")

            op = described_class.(deposit_request: {
              asset_code: "BTCT",
            })

            expect(op).to be_failure
            expect(op["contract.default"].errors[:account_id])
              .to include "can't be blank"
          end
        end
      end # Create
    end # Operations
  end # DepositRequests
end # StellarBase
