module StellarBase
  module AccountSubscriptions
    class GetCursor

      extend LightService::Action
      expects :account_subscription, :stellar_sdk_client
      promises :cursor

      executed do |c|
        c.cursor = c.account_subscription.cursor

        next c if c.cursor.present?

        address = c.account_subscription.address

        c.cursor = c.stellar_sdk_client.horizon.
          account(account_id: address).
          operations(order: "desc", limit: 1).records.first.id

      rescue Faraday::ClientError => e
        c.fail_and_return! "Skipping fetching cursor of #{address} due to #{e.inspect}"
      end

    end
  end
end
