module StellarBase
  module AccountSubscriptions
    class SaveCursor

      extend LightService::Action
      expects :account_subscription, :remote_operations

      executed do |c|
        last_operation = c.remote_operations.last
        c.account_subscription.update!(cursor: last_operation["id"])
      end

    end
  end
end
