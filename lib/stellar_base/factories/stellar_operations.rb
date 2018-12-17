FactoryBot.define do
  factory(:stellar_base_stellar_operation, {
    class: "StellarBase::StellarOperation"
  }) do
    operation_id "id"
    transaction_hash "tx1234"
    association(:stellar_transaction, {
      factory: :stellar_base_stellar_transaction,
    })
  end

  factory(:stellar_base_stellar_payment, {
    class: "StellarBase::StellarPayment",
    parent: :stellar_base_stellar_operation,
  }) do
    asset_code nil
    asset_issuer nil
    from "G-SOURCE"
    to "G-RECIPIENT"
    amount 10.0
    association(:stellar_transaction, {
      factory: :stellar_base_stellar_transaction,
    })
  end
end
