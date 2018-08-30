module StellarBase
  module BridgeCallbacks
    class BridgeCallbackPolicy

      def initialize(_, _)
      end

      def create?
        StellarBase.included_module?(:bridge_callbacks)
      end

    end
  end
end
