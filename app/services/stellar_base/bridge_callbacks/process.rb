module StellarBase
  module BridgeCallbacks
    class Process
      def self.call(callback)
        callback_class.(callback)
      end

      private

      def self.callback_class
        on_bridge_callback = StellarBase.configuration.on_bridge_callback
        return on_bridge_callback if on_bridge_callback.respond_to?(:call)
        on_bridge_callback.constantize
      rescue NameError
        error_message = [
          "StellarBase.on_bridge_callback isn't configured or the",
          "configured callback class doesn't exist:",
          StellarBase.configuration.on_bridge_callback,
        ].join(" ")

        raise NameError, error_message
      end
    end
  end
end
