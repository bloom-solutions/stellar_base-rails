module StellarBase
  module AccountSubscriptions
    class ExecuteAccountSubscriptionCallback

      extend LightService::Action
      expects :account_subscription, :tx, :operation, :on_account_event

      executed do |c|
        next c if c.on_account_event.nil?

        c.on_account_event.(
          c.account_subscription.address,
          c.tx,
          c.operation,
        )
      end

    end
  end
end
