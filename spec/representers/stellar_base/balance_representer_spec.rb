require "spec_helper"

module StellarBase
  RSpec.describe BalanceRepresenter do

    it "exposes the attributes" do
      balance = Balance.new(asset_code: "BTCT", amount: 1.5)

      representer = described_class.new(balance)
      serialized = representer.to_hash.with_indifferent_access

      expect(serialized[:amount]).to eq 1.5
      expect(serialized[:asset_code]).to eq "BTCT"
    end

  end
end
