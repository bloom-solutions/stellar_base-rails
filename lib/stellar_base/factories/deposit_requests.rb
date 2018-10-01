FactoryBot.define do
  factory :stellar_base_deposit_request, class: "StellarBase::DepositRequest" do
    deposit_address { "dep-addr" }
    asset_type { "crypto" }
    issuer { "issuer-addr" }
    memo_type { "text" }
    memo { "ABAC" }
    min_amount { 0 }
    max_amount { 0 }
    email_address { "test@test.com" }
    account_id { "G-STELLAR-ACCT" }
    deposit_type { "" }
    fee_fixed { 0 }
    fee_percent { 0 }
  end
end
