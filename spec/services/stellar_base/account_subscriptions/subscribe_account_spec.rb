require 'spec_helper'

module StellarBase
  RSpec.describe SubscribeAccount do

    let(:account_subscription) do
      create(:stellar_base_account_subscription, {
        address: "GBRPYHIL2CI3FNQ4BXLFMNDLFJUNPU2HY3ZMFSHONUCEOASW7QC7OX2H",
        cursor: nil,
      })
    end

    it "executes the configured callback per operation", vcr: {record: :once} do
      expect(StellarBase.configuration.on_account_event).to receive(:call).
        exactly(10).times.
        and_call_original
      result = described_class.(account_subscription, operation_limit: 10)

      expect(result).to be_success
      expect(result.operations.first).to be_a StellarOperation
      expect(result.tx).to be_a StellarTransaction
    end

  end
end
