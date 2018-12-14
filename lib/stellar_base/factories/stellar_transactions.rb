FactoryBot.define do
  factory :stellar_base_stellar_transaction, class: "StellarBase::StellarTransaction" do
    id
    hash
    paging_token
    memo
    memo_type
    created_at
    source_account
    source_account_sequence
    ledger
    fee_paid
    operation_count

    skip_create
  end
end
