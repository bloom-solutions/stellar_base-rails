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
        let(:bridge_callback) do
          create(:stellar_base_bridge_callback, {
            amount: 1.0,
            asset_code: "BTCT",
            asset_issuer: ENV["ISSUER_ADDRESS"],
            memo_type: "text",
            memo: "ABAKADA",
          })
        end

        it "returns the correct withdrawal_request" do
          resulting_ctx = described_class.execute(
            bridge_callback: bridge_callback
          )
          expect(resulting_ctx.withdrawal_request).to eq withdrawal_request
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
        let(:bridge_callback) do
          create(:stellar_base_bridge_callback, {
            amount: 1.0,
            asset_code: "BTCT",
            asset_issuer: "btct-issuer",
            memo_type: "text",
            memo: "ABAKADA",
          })
        end

        it "skips the rest of the actions" do
          resulting_ctx = described_class.execute(
            bridge_callback: bridge_callback
          )
          expect(resulting_ctx).to be_skip_remaining
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
        let(:bridge_callback) do
          create(:stellar_base_bridge_callback, {
            amount: 1.0,
            asset_code: "BTCT",
            asset_issuer: "btct-issuer",
            memo_type: "text",
            memo: "ABAKADA",
          })
        end

        it "skips the rest of the actions" do
          resulting_ctx = described_class.execute(
            bridge_callback: bridge_callback
          )
          expect(resulting_ctx).to be_skip_remaining
        end
      end

    end
  end
end
