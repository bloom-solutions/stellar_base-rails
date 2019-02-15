module StellarBase
  module AccountSubscriptions
    class GetRemoteTransaction

      extend LightService::Action
      expects :stellar_sdk_client, :remote_operation
      promises :remote_transaction

      executed do |c|
        hash = c.remote_operation["transaction_hash"]
        c.remote_transaction = c.stellar_sdk_client.horizon.
          transaction(hash: hash).to_hash
      rescue Faraday::ResourceNotFound
        raise NotFoundError, "transaction #{hash} not found"
      end

    end
  end
end
