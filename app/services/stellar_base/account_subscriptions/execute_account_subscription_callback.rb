module StellarBase
  module AccountSubscriptions
    class ExecuteAccountSubscriptionCallback

      extend LightService::Action
      expects(*%i[
        account_subscription
        stellar_operation
        on_account_event
      ])

      executed do |c|
        next c if c.on_account_event.nil?
        c.on_account_event.(c.account_subscription.address, c.stellar_operation)
      end

    end
  end
end
