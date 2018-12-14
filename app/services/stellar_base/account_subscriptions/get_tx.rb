module StellarBase
  module AccountSubscriptions
    class GetTx

      extend LightService::Action
      expects :stellar_sdk_client, :operation
      promises :tx

      executed do |c|
        hash = c.operation.transaction_hash
        tx_json = c.stellar_sdk_client.horizon.transaction(hash: hash)
        c.tx = StellarTransaction.new(tx_json)
      end

    end
  end
end
