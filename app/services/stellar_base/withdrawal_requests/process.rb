module StellarBase
  module WithdrawalRequests
    class Process

      extend LightService::Organizer

      def self.call(
        bridge_callback,
        on_withdraw: StellarBase.configuration.on_withdraw
      )
        with(
          bridge_callback: bridge_callback,
          on_withdraw: on_withdraw,
        ).reduce(actions)
      end

      def self.actions
        [
          FindWithdrawalRequest,
          CallOnWithdraw,
        ]
      end
      private_class_method :actions

    end
  end
end
