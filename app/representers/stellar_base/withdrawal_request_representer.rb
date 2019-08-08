module StellarBase
  class WithdrawalRequestRepresenter < ApplicationRepresenter

    property :account_id
    property :memo_type
    property :memo
    property :min_amount
    property :max_amount
    property :fee_fixed
    property :fee_percent
    property :extra_info

  end
end
