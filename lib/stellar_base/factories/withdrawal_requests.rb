FactoryBot.define do

  factory(:stellar_base_withdrawal_request, {
    class: "StellarBase::WithdrawalRequest",
  }) do
    asset_type "crypto"
    asset_code "BTC"
    issuer "issuer"
    memo_type "text"
    dest "destination"
    sequence(:memo) {|n| "XYZ#{n}" }
  end

end
