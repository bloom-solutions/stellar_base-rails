module StellarBase
  module BridgeCallbacks
    class GetTransaction
      extend LightService::Action
      expects :client, :transaction_id
      promises :transaction_response

      executed do |c|
        c.fail_and_return! unless c.transaction_id.present?

        id = c.transaction_id
        response = c.client.get_transaction(id)

        if !response.present?
          c.fail_and_return! "Transaction ##{id} doesn't exist"
        end

        c.transaction_response = response
      end

    end
  end
end
