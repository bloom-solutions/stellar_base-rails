module StellarBase
  module DepositRequests
    class FindConfig

      extend LightService::Action

      expects :network
      promises :deposit_config

      executed do |c|
        depositable_assets = StellarBase.configuration.depositable_assets
        c.deposit_config = depositable_assets.find do |asset|
          asset[:network] == c.network
        end

        if c.deposit_config.blank?
          c.fail_and_return! "No depositable_asset config for #{c.network}"
        end
      end

    end
  end
end
