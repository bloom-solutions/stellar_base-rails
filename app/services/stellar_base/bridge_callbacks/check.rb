module StellarBase
  module BridgeCallbacks
    class Check
      extend LightService::Organizer

      def self.call(opts = {})
        with(opts).reduce(
          InitializeHorizonClient,
          GetOperation,
          GetTransaction,
          Compare,
        )
      end

    end
  end
end
