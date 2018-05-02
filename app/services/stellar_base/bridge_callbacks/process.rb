module StellarBase
  module BridgeCallbacks
    class Process
      def self.call(callback)
        callback_class.(callback)
      rescue NameError => e
        error_message = [
          "StellarBase.on_bridge_callback isn't configured or the",
          "configured callback class doesn't exist:",
          StellarBase.configuration.on_bridge_callback,
        ].join(" ")

        raise NameError, error_message
      end

      private

      def self.callback_class
        StellarBase.configuration.on_bridge_callback.constantize
      end
    end
  end
end
