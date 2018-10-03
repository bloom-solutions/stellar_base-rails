module StellarBase
  module AccountSubscriptions
    class ExecuteCallback

      extend LightService::Action
      expects :account_subscription, :tx, :operation

      executed do |c|
        StellarBase.configuration.on_account_event.(
          c.account_subscription.address,
          c.tx,
          c.operation,
        )
      end

    end
  end
end
