module StellarBase
  class DepositRequestTwin < ApplicationTwin

    property :deposit_address
    property :eta
    property :min_amount
    property :max_amount
    property :fee_fixed
    property :fee_percent
    property :extra_info

  end
end
