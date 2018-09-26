module StellarBase
  module DepositRequests
    class FindDepositableAsset

      def self.call(asset_code)
        depositable_assets = StellarBase.configuration.depositable_assets
        depositable_assets.find {|asset| asset[:asset_code] == asset_code }
      end

    end
  end
end
