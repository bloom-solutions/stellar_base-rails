FactoryBot.define do
  factory(:stellar_base_stellar_operation, {
    class: "StellarBase::StellarOperation"
  }) do
    id "id"
    paging_token "1234"
    source_account "G-TEST"
    type "payment"
    type_i { 1 }
    created_at { Time.zone.now }
    transaction_hash "tx1234"
    asset_type "native"
    asset_code nil
    asset_issuer nil
    from "G-SOURCE"
    to "G-RECIPIENT"
    amount 10.0

    skip_create
  end
end
