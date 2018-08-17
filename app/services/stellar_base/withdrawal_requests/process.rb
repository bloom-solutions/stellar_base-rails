module StellarBase
  module WithdrawalRequests
    class Process

      def self.call(bridge_callback, on_withdraw: StellarBase.on_withdraw)
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
      private_method :actions

    end
  end
end
