require 'spec_helper'

module StellarBase
  RSpec.describe DepositRequestRepresenter do

    it "exposes the attributes" do
      deposit = build_stubbed(:stellar_base_deposit_request, {
        deposit_address: "BTC-ADDR",
        eta: 600,
        min_amount: 0.0,
        max_amount: 100.0,
        fee_fixed: 0,
        fee_percent: 0,
        extra_info: "extra info",
      })

      twin = DepositRequestTwin.new(deposit)
      representer = described_class.new(twin)
      serialized = representer.to_hash.with_indifferent_access

      expect(serialized[:how]).to eq "BTC-ADDR"
      expect(serialized[:eta]).to eq 600
      expect(serialized[:min_amount]).to eq 0
      expect(serialized[:max_amount]).to eq 100.0
      expect(serialized[:fee_fixed]).to eq 0
      expect(serialized[:fee_percent]).to eq 0
      expect(serialized[:extra_info]).to eq "extra info"
    end

  end
end
