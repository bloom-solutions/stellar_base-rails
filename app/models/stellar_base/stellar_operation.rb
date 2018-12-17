module StellarBase
  class StellarOperation < ApplicationRecord

    include Storext.model
    store :data, coder: JSON

    belongs_to(:stellar_transaction, {
      class_name: "StellarBase::StellarTransaction",
      primary_key: :transaction_id,
      foreign_key: :transaction_hash,
    })

  end
end
