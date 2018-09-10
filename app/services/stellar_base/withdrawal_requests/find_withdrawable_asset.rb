module StellarBase
  module WithdrawalRequests
    class FindWithdrawableAsset

      def self.call(asset_code)
        withdrawable_assets = StellarBase.configuration.withdrawable_assets
        withdrawable_assets.find {|asset| asset[:asset_code] == asset_code }
      end

    end
  end
end
