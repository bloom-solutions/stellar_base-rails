module StellarBase
  module AccountSubscriptions
    class GetTx

      extend LightService::Action
      expects :stellar_sdk_client, :operation
      promises :transaction

      executed do |c|
        hash = c.operation.transaction_hash
        tx_json = c.stellar_sdk_client.horizon.transaction(hash: hash)
        c.transaction = StellarTransaction.new(raw: tx_json)
      end

    end
  end
end
