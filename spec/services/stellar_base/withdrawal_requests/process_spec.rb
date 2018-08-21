require 'spec_helper'

module StellarBase
  module WithdrawalRequests
    RSpec.describe self::Process do

      context "payment matches a withdrawal_request and memo" do
        let!(:withdrawal_request) do
          create(:stellar_base_withdrawal_request, {
            asset_type: "crypto",
            asset_code: "BTCT",
            issuer: CONFIG[:issuer_address],
            memo_type: "text",
            memo: "ABAKADA",
          })
        end
        let(:bridge_callback) do
          create(:stellar_base_bridge_callback, {
            amount: 1.0,
            asset_code: "BTCT",
            asset_issuer: CONFIG[:issuer_address],
            memo_type: "text",
            memo: "ABAKADA",
          })
        end

        it "calls .on_withdraw processor" do
          expect(ProcessWithdrawal).to receive(:call).
            with(withdrawal_request, bridge_callback)

          described_class.(bridge_callback)
        end
      end

    end
  end
end
