module StellarBase
  class InitStellarClient

    extend LightService::Action
    promises :stellar_sdk_client

    executed do |c|
      c.stellar_sdk_client = Stellar::Client.new(
        horizon: StellarBase.configuration.horizon_url,
      )
    end

  end
end
