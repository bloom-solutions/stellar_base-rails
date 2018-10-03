module StellarBase
  class Deposit < ApplicationRecord

    belongs_to :deposit_request, class_name: "StellarBase::DepositRequest"

  end
end
