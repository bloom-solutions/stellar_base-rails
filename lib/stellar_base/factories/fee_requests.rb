FactoryBot.define do

  factory :stellar_base_fee_request, class: "StellarBase::FeeRequest" do
    asset_code { "BTCT" }
    amount { 0.001 }
    operation { "deposit" }
    type { nil }
    fee_response { nil }
  end

end
