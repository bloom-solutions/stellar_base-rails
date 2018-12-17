require 'spec_helper'

module StellarBase
  module AccountSubscriptions
    RSpec.describe ProcessWithdrawal do

      let(:op) { build_stubbed(:stellar_base_stellar_payment) }

      it "executes the `#{WithdrawalRequests::Process}`" do
        expect(WithdrawalRequests::Process).to receive(:call).with(op)
        described_class.execute(stellar_operation: op)
      end

    end
  end
end
