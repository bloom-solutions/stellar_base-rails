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

        operation_records = c.stellar_sdk_client.horizon.
          account(account_id: address).
          operations(order: "desc", limit: 1).records

        if operation_records.empty?
          c.fail_and_return!("No operations available")
        end

        c.cursor = operation_records.first.id

        c.account_subscription.update_attributes!(cursor: c.cursor)
      rescue Faraday::ClientError => e
        c.fail_and_return! "Skipping fetching cursor of #{address} " \
          "due to #{e.inspect}"
      end

    end
  end
end
