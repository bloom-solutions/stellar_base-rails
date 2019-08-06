module StellarBase
  module FeeRequests
    module Contracts
      class Show < ApplicationContract

        property :operation
        property :type
        property :asset_code
        property :amount

        OPERATION_TYPES = %w[deposit withdraw].freeze

        validates :operation, presence: true, inclusion: { in: OPERATION_TYPES }
        validates(:asset_code, :amount, presence: true)

        validate :check_valid_asset_code

        def check_valid_asset_code
          return if operation.blank?
          asset_codes = if operation == "deposit"
                          StellarBase.configuration.depositable_assets
                            &.map do |asset|
                              asset[:asset_code]
                            end
                        else
                          StellarBase.configuration.withdrawable_assets
                            &.map do |asset|
                              asset[:asset_code]
                            end
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
