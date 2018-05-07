module StellarBase
  module BridgeCallbacks
    class Check
      extend LightService::Organizer

      def self.call(opts = {})
        with(opts).reduce(
          InitializeHorizonClient,
          GetOperation,
          GetTransaction,
        )
      end

    end
  end
end
