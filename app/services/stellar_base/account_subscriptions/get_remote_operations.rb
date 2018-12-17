module StellarBase
  module AccountSubscriptions
    class GetRemoteOperations

      extend LightService::Action
      expects(
        :cursor,
        :account_subscription,
        :stellar_sdk_client,
        :operation_limit,
      )
      promises :remote_operations

      executed do |c|
        address = c.account_subscription.address

        c.remote_operations = c.stellar_sdk_client
          .horizon
          .account(account_id: address)
          .operations(order: "asc", cursor: c.cursor, limit: c.operation_limit)
          .records.map(&:to_hash)

        if c.remote_operations.empty?
          c.fail_and_return! "No operations found for #{address}"
        end
      rescue Faraday::ClientError => e
        c.fail_and_return! "Skipping fetching operations of #{address} " \
          "due to #{e.inspect}"
      end

    end
  end
end
