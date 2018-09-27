require 'spec_helper'

module StellarBase
  RSpec.describe WithdrawalRequestRepresenter do

    it "exposes the attributes" do
      withdrawal_request = build_stubbed(:stellar_base_withdrawal_request, {
        account_id: "account_id",
        min_amount: 1.0,
        max_amount: 10.0,
        fee_fixed: 0.01,
        fee_percent: 1.0,
        fee_network: 0.001,
        memo_type: "text",
        memo: "ABC",
        extra_info: "extra info",
      })

      twin = WithdrawalRequestTwin.new(withdrawal_request)
      representer = described_class.new(twin)
      serialized = representer.to_hash.with_indifferent_access

      expect(serialized[:account_id]).to eq "account_id"
      expect(serialized[:memo_type]).to eq "text"
      expect(serialized[:memo]).to eq "ABC"
      expect(serialized[:min_amount]).to eq 1.0
      expect(serialized[:max_amount]).to eq 10.0
      expect(serialized[:fee_fixed]).to eq 0.01
      expect(serialized[:fee_percent]).to eq 1.0
      expect(serialized[:fee_network]).to eq 0.001
      expect(serialized[:extra_info]).to eq "extra info"
    end

  end
end
