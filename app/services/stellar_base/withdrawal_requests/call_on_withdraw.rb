module StellarBase
  module WithdrawalRequests
    class CallOnWithdraw

      extend LightService::Action
      expects :withdrawal_request, :stellar_operation, :on_withdraw

      ON_WITHDRAW_ERROR = "`on_withdraw` must be a string of an object " \
        "that responds to `.call` or the object itself"

      executed do |c|
        next c if c.on_withdraw.nil?
        callback = callback_from(c.on_withdraw)
        callback.(c.withdrawal_request, c.stellar_operation)
      end

      def self.callback_from(on_withdraw)
        on_withdraw = GetCallbackFrom.(on_withdraw)

        if !on_withdraw.respond_to?(:call)
          fail ArgumentError, ON_WITHDRAW_ERROR
        end

        on_withdraw
      end

    end
  end
end
