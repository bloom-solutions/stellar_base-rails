module StellarBase
  module AccountSubscriptions
    class GetCursor

      extend LightService::Action
      expects :account_subscription, :stellar_sdk_client
      promises :cursor

      executed do |c|
        c.cursor = c.account_subscription.cursor

        next c if c.cursor.present?

        c.cursor = c.stellar_sdk_client.horizon.
          account(account_id: c.account_subscription.address).
          operations(order: "desc", limit: 1).records.first.id
      end

    end
  end
end
