FactoryBot.define do
  factory :stellar_base_stellar_operation, class: "StellarBase::StellarOperation" do
    id
    paging_token
    source_account
    type
    type_i
    created_at
    transaction_hash
    asset_type
    asset_code
    asset_issuer
    from
    to
    amount

    skip_create
  end
end
