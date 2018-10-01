module StellarBase
  module DepositRequests
    class InitStellarAsset

      extend LightService::Action
      expects :deposit_request, :issuer_account
      promises :stellar_asset

      executed do |c|
        c.stellar_asset = Stellar::Asset.alphanum4(
          c.deposit_request.asset_code,
          c.issuer_account.keypair,
        )
      end

    end
  end
end
