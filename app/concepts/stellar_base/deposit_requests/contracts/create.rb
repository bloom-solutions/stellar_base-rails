module StellarBase
  module DepositRequests
    module Contracts
      class Create < ApplicationContract

        property :asset_code
        property :account_id
        property :memo_type
        property :memo
        property :email_address
        property :deposit_type

        validates(
          :asset_code,
          :account_id,
          presence: true,
        )
        validate :check_valid_asset_code

        def check_valid_asset_code
          asset_codes = StellarBase.configuration.depositable_assets.dup

          if asset_codes.nil?
            errors.add(:asset_code, "no assets configured for deposits")
            return
          end

          asset_codes.map! { |asset| asset[:asset_code] }

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
