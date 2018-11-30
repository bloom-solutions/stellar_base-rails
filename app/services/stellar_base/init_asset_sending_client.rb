module StellarBase
  class InitAssetSendingClient

    extend LightService::Action
    expects :sending_strategy, :horizon_url
    promises :asset_sending_client

    executed do |c|
      sending_strategy = Array(c.sending_strategy)
      if sending_strategy.first == :stellar_sdk
        client = Stellar::Client.new(horizon: c.horizon_url)
      elsif sending_strategy.first == :stellar_spectrum
        config = sending_strategy.last.merge(horizon_url: c.horizon_url)
        client = StellarSpectrum.new(config)
      end

      c.asset_sending_client = client
    end

  end
end
