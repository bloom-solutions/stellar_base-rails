module StellarBase
  module Balances
    module Contracts
      class Create < ApplicationContract

        property :asset_code

        validates :asset_code, presence: true
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
