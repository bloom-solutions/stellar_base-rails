module StellarBase
  module BridgeCallbacks
    class InitializeHorizonClient
      extend LightService::Action

      promises :client

      executed do |c|
        c.client = HorizonClient.new
      end
    end
  end
end
