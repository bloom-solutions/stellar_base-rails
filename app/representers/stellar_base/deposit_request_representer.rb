module StellarBase
  class DepositRequestRepresenter < ApplicationRepresenter

    property :deposit_address, as: :how
    property :eta
    property :min_amount
    property :max_amount
    property :fee_fixed
    property :fee_percent
    property :extra_info

  end
end
