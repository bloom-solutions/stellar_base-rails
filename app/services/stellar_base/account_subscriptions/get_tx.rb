module StellarBase
  module AccountSubscriptions
    class GetTx

      extend LightService::Action
      expects :stellar_sdk_client, :operation
      promises :tx

      executed do |c|
        hash = c.operation.transaction_hash
        c.tx = c.stellar_sdk_client.horizon.transaction(hash: hash)
      end

    end
  end
end
