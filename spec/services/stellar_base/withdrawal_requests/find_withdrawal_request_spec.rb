require 'spec_helper'

module StellarBase
  module WithdrawalRequests
    RSpec.describe FindWithdrawalRequest do

      context "payment matches a withdrawal_request" do
        let!(:withdrawal_request) do
          create(:stellar_base_withdrawal_request, {
            asset_type: "crypto",
            asset_code: "BTCT",
            issuer: ENV["ISSUER_ADDRESS"],
            memo_type: "text",
            memo: "ABAKADA",
          })
        end
        let(:tx) do
          build(:stellar_base_stellar_transaction, {
            memo_type: "text",
            memo: "ABAKADA",
          })
        end
        let(:op) do
          build(:stellar_base_stellar_payment, {
            asset_code: "BTCT",
            asset_issuer: ENV["ISSUER_ADDRESS"],
            amount: 1.0,
            stellar_transaction: tx,
          })
        end

        it "returns the correct withdrawal_request" do
          result = described_class.execute(stellar_operation: op)
          expect(result.withdrawal_request).to eq withdrawal_request
        end
      end

      context "payment matches memo but not other details" do
        let!(:withdrawal_request) do
          create(:stellar_base_withdrawal_request, {
            asset_type: "crypto",
            asset_code: "BTC",
            issuer: "btc-issuer",
            memo_type: "text",
            memo: "ABAKADA",
          })
        end
        let(:tx) do
          build(:stellar_base_stellar_transaction, {
            memo_type: "text",
            memo: "ABAKADA",
          })
        end
        let(:op) do
          build(:stellar_base_stellar_payment, {
            asset_code: "BTC",
            asset_issuer: ENV["ISSUER_ADDRESS"],
            amount: 1.0,
            stellar_transaction: tx,
          })
        end

        it "skips the rest of the actions" do
          result = described_class.execute(stellar_operation: op)
          expect(result).to be_skip_remaining
        end
      end

      context "payment does not match any memo" do
        let!(:withdrawal_request) do
          create(:stellar_base_withdrawal_request, {
            asset_type: "crypto",
            asset_code: "BTC",
            issuer: "btc-issuer",
            memo_type: "text",
            memo: "HELLO",
          })
        end
        let(:tx) do
          build(:stellar_base_stellar_transaction, {
            memo_type: "text",
            memo: "ABAKADA",
          })
        end
        let(:op) do
          build(:stellar_base_stellar_payment, {
            asset_code: "BTC",
            asset_issuer: ENV["ISSUER_ADDRESS"],
            amount: 1.0,
            stellar_transaction: tx,
          })
        end

        it "skips the rest of the actions" do
          result = described_class.execute(stellar_operation: op)
          expect(result).to be_skip_remaining
        end
      end

    end
  end
end
