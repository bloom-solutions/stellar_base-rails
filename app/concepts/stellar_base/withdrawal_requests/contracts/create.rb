module StellarBase
  module WithdrawalRequests
    module Contracts
      class Create < ApplicationContract

        property :asset_type
        property :asset_code
        property :dest
        property :dest_extra
        property :issuer
        property :account_id
        property :memo_type
        property :memo
        property :eta
        property :min_amount
        property :max_amount
        property :fee_fixed
        property :fee_percent
        property :fee_network

        validates(
          *%i[
            asset_type
            asset_code
            dest
            issuer
            account_id
            fee_network
            fee_fixed
            fee_percent
          ],
          presence: true
        )

      end
    end
  end
end
