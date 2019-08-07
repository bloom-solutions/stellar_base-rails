require "spec_helper"

module StellarBase
  module WithdrawalRequests
    module Operations
      RSpec.describe Create do

        it "Can request withdrawal" do
          expect(GenMemoFor).to receive(:call).with(WithdrawalRequest)
            .and_return("MEMO")
          expect(DetermineMaxAmount).to receive(:call).and_return(10)
          expect(DetermineFee).to receive(:call).with(nil).and_return(0.0)

          op = described_class.(withdrawal_request: {
            type: "crypto",
            asset_code: "BTCT",
            dest: "my-btc-addr",
            dest_extra: "pls",
            fee_fixed: 0.911,
          })

          expect(op).to be_success
          withdrawal_request = op["model"]
          expect(withdrawal_request.asset_type).to eq "crypto"
          expect(withdrawal_request.asset_code).to eq "BTCT"
          expect(withdrawal_request.dest).to eq "my-btc-addr"
          expect(withdrawal_request.dest_extra).to eq "pls"
          expect(withdrawal_request.issuer).to eq ENV["ISSUER_ADDRESS"]
          expect(withdrawal_request.account_id)
            .to eq StellarBase.configuration.distribution_account
          expect(withdrawal_request.memo_type).to eq "text"
          expect(withdrawal_request.memo).to be_present
          expect(withdrawal_request.eta).to be_an Integer
          expect(withdrawal_request.min_amount).to be_a BigDecimal
          expect(withdrawal_request.max_amount).to eq 10
          expect(withdrawal_request.fee_fixed).to eq 0.911
          expect(withdrawal_request.fee_percent).to be_zero
        end

        context "Cannot request withdrawal" do
          before do
            StellarBase.configure do |c|
              c.modules = %w[bridge_callbacks]
            end
          end

          it "returns a policy error message" do
            op = described_class.(withdrawal_request: {
              type: "crypto",
              asset_code: "BTCT",
              dest: "my-btc-addr",
              dest_extra: "pls",
            })

            expect(op).to_not be_success
            expect(op["result.policy.default"]).to_not be_success
            expect(op["result.policy.message"]).to eq described_class::POLICY_ERROR_MESSAGE
          end
        end

        context "an asset that cannot be withdrawn" do
          it "is not successful" do
            op = described_class.(withdrawal_request: {
              type: "crypto",
              asset_code: "BCHT",
              dest: "my-bch-addr",
            })

            expect(op).to_not be_success

            contract = op["contract.default"]

            expect(contract.errors[:asset_code])
              .to include "invalid asset_code. Valid asset_codes: BTCT"
          end
        end

        context "bridge_callbacks module is not loaded" do
          before do
            StellarBase.configuration.modules = %i[]
          end

          it "creates a withdrawal request" do
            op = described_class.(withdrawal_request: {
              type: "crypto",
              asset_code: "BTCT",
              dest: "my-btc-addr",
              dest_extra: "pls",
            })

            expect(op).to_not be_success
          end
        end

      end
    end
  end
end
