module StellarBase
  module AccountSubscriptions
    class SaveCursor

      extend LightService::Action
      expects :account_subscription, :operations

      executed do |c|
        c.account_subscription.update!(cursor: c.operations.last.id)
      end

    end
  end
end
