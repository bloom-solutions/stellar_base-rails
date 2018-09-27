require 'spec_helper'

module StellarBase
  RSpec.describe DepositRequestTwin do

    it "exposes the rest of the attributes without renaming" do
      deposit = build_stubbed(:stellar_base_deposit_request, {
        deposit_address: "BTC-ADDR",
        eta: 600,
        min_amount: 0.0,
        max_amount: 100.0,
        fee_fixed: 0,
        fee_percent: 0,
        extra_info: "extra info",
      })

      twin = described_class.new(deposit)

      expect(twin.deposit_address).to eq "BTC-ADDR"
      expect(twin.eta).to eq 600
      expect(twin.min_amount).to eq 0
      expect(twin.max_amount).to eq 100.0
      expect(twin.fee_fixed).to eq 0
      expect(twin.fee_percent).to eq 0
      expect(twin.extra_info).to eq "extra info"
    end

  end
end
