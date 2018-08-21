require 'spec_helper'

RSpec.describe WithdrawalRequestTwin do

  it "exposes the rest of the attributes without renaming" do
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

    twin = described_class.new(withdrawal_request)

    expect(twin.account_id).to eq "account_id"
    expect(twin.memo_type).to eq "text"
    expect(twin.memo).to eq "ABC"
    expect(twin.min_amount).to eq 1.0
    expect(twin.max_amount).to eq 10.0
    expect(twin.fee_fixed).to eq 0.01
    expect(twin.fee_percent).to eq 1.0
    expect(twin.fee_network).to eq 0.001
    expect(twin.extra_info).to eq "extra info"
  end

end
