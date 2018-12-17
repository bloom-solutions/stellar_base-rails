require 'spec_helper'

module StellarBase
  module WithdrawalRequests
    RSpec.describe self::Process do

      context "payment matches a withdrawal_request and memo" do
        let(:withdrawal_request) do
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
          build(:stellar_base_stellar_operation, {
            asset_code: "BTCT",
            asset_issuer: ENV["ISSUER_ADDRESS"],
          })
        end

        it "calls .on_withdraw processor" do
          expect(ProcessWithdrawal).to receive(:call).
            with(withdrawal_request, tx, op)

          described_class.(tx, op)
        end
      end

    end
  end
end
