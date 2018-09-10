module StellarBase
  module WithdrawalRequests
    module Contracts
      class Create < ApplicationContract

        property :asset_type
        property :asset_code
        property :dest
        property :dest_extra
        property :fee_network

        validates(
          :asset_type,
          :asset_code,
          :dest,
          :fee_network,
          presence: true,
        )
        validate :check_valid_asset_code

        def check_valid_asset_code
          asset_codes = StellarBase.configuration.withdrawable_assets
            &.map do |asset|
              asset[:asset_code]
            end

          return if asset_codes.include? asset_code

          errors.add(
            :asset_code,
            "invalid asset_code. Valid asset_codes: #{asset_codes.join(', ')}",
          )
        end

      end
    end
  end
end
