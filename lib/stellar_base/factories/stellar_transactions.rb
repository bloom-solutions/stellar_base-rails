FactoryBot.define do
  factory :stellar_base_stellar_transaction, class: "StellarBase::StellarTransaction" do
    id "1234"
    hash "1234"
    paging_token "1234"
    memo ""
    memo_type "none"
    created_at { Time.zone.now }
    source_account "G-SOURCE"
    source_account_sequence "1234"
    ledger "1098"
    fee_paid 100
    operation_count 1

    skip_create
  end
end
