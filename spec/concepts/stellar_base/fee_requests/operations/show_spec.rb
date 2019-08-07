require "spec_helper"

module StellarBase
  module FeeRequests
    module Operations
      RSpec.describe Show do

        it "Can request withdraw fees" do
          op = described_class.(fee_request: {
            asset_code: "BTCT",
            operation: "withdraw",
            amount: 0.01,
          })

          expect(op).to be_success
          fee_request = op["model"]
          expect(fee_request.asset_code).to eq "BTCT"
          expect(fee_request.operation).to eq "withdraw"
          expect(fee_request.amount).to eq 0.01
          expect(fee_request.type).to be_nil

          # from GetWithdrawFixedFeeQuoteFrom
          expect(fee_request.fee_response).to eq 0.0001
        end

        it "Can request deposit fees" do
          op = described_class.(fee_request: {
            asset_code: "BTCT",
            operation: "deposit",
            amount: 0.01,
          })

          expect(op).to be_success
          fee_request = op["model"]
          expect(fee_request.asset_code).to eq "BTCT"
          expect(fee_request.operation).to eq "deposit"
          expect(fee_request.amount).to eq 0.01
          expect(fee_request.type).to be_nil

          # fixed_fee_quote_from is not configured for depositable_assets -> BTCT
          expect(fee_request.fee_response).to be_zero
        end

        context "module is not loaded" do
          before do
            StellarBase.configure do |c|
              c.modules = %w[fees]
            end
          end

          it "returns a policy error message" do
            op = described_class.(withdrawal_request: {
              asset_code: "BTCT",
              operation: "withdraw",
              amount: 0.01,
            })

            expect(op).to_not be_success
            expect(op["result.policy.default"]).to_not be_success
            expect(op["result.policy.message"])
              .to eq described_class::POLICY_ERROR_MESSAGE
          end
        end
      end

    end
  end
end
