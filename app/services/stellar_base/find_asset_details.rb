module StellarBase
  class FindAssetDetails

    def self.call(operation:, asset_code:)
      return nil if operation.blank?
      return nil if asset_code.blank?

      assets = if operation == "deposit"
                 StellarBase.configuration.depositable_assets
               elsif operation == "withdraw"
                 StellarBase.configuration.withdrawable_assets
               else
                 []
               end
      assets.find {|asset| asset[:asset_code] == asset_code }
    end

  end
end
