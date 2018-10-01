FactoryBot.define do
  factory :stellar_base_deposit, class: "StellarBase::Deposit" do
    stellar_operation_id { "issuer-addr" }
    deposit_request do
      StellarBase::DepositRequest.first ||
        association(:stellar_base_deposit_request)
    end
    tx_id { "dep-addr" }
    amount { "crypto" }
  end
end
