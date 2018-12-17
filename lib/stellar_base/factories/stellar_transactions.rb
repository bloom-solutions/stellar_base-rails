FactoryBot.define do
  factory :stellar_base_stellar_transaction, class: "StellarBase::StellarTransaction" do
    transaction_id { "1234" }
    memo_type { "text" }
    memo { "VBA" }
  end
end
