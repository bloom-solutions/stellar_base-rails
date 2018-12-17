module StellarBase
  class StellarTransaction < ApplicationRecord

    has_many(:stellar_operations, {
      class_name: "StellarBase::StellarOperation",
      primary_key: :transaction_id,
      foreign_key: :transaction_hash,
    })

  end
end
