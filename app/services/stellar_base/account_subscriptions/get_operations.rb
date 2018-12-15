module StellarBase
  module AccountSubscriptions
    class GetOperations

      extend LightService::Action
      expects(
        :cursor,
        :account_subscription,
        :stellar_sdk_client,
        :operation_limit,
      )
      promises :operations

      executed do |c|
        address = c.account_subscription.address

        c.operations = c.stellar_sdk_client
          .horizon
          .account(account_id: address)
          .operations(order: "asc", cursor: c.cursor, limit: c.operation_limit)
          .records
          .map do |op|
            StellarOperation.new(op)
          end

        if c.operations.empty?
          c.fail_and_return! "No operations found for #{address}"
        end
      rescue Faraday::ClientError => e
        c.fail_and_return! "Skipping fetching operations of #{address} " \
          "due to #{e.inspect}"
      end

    end
  end
end
