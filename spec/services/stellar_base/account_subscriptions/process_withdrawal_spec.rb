require 'spec_helper'

module StellarBase
  module AccountSubscriptions
    RSpec.describe ProcessWithdrawal do

      let(:account_subscription) { create(:account_subscription) }
      let(:tx) { build_stubbed(:stellar_base_stellar_transaction) }
      let(:op) { build_stubbed(:stellar_base_stellar_operation) }

      it "executes the `#{WithdrawalRequests::Process}`" do
        expect(WithdrawalRequests::Process).to receive(:call).with(tx, op)
        described_class.execute(tx: tx, operation: op)
      end

    end
  end
end
