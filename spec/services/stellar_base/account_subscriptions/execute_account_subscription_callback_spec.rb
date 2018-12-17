require 'spec_helper'

module StellarBase
  module AccountSubscriptions
    RSpec.describe ExecuteAccountSubscriptionCallback do

      let(:account_subscription) do
        build_stubbed(:stellar_base_account_subscription)
      end
      let(:op) { build(:stellar_base_stellar_operation) }

      context "`.on_account_event` is present" do
        it "calls the callback" do
          callback = ->(address, op) {}
          expect(callback).to receive(:call).
            with(account_subscription.address, op)

          described_class.execute(
            account_subscription: account_subscription,
            stellar_operation: op,
            on_account_event: callback,
          )
        end
      end

      context "`.on_account_event` is nil" do
        it "does nothing" do
          result = described_class.execute(
            account_subscription: account_subscription,
            stellar_operation: op,
            on_account_event: nil
          )

          expect(result).to be_success
        end
      end

    end
  end
end
