module StellarBase
  module WithdrawalRequests
    class Process

      extend LightService::Organizer

      def self.call(
        operation,
        on_withdraw: StellarBase.configuration.on_withdraw
      )
        with(
          stellar_operation: operation,
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
