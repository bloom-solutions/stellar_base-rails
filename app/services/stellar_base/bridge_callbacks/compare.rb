module StellarBase
  module BridgeCallbacks
    class Compare
      extend LightService::Action
      expects :operation_response, :transaction_response, :params

      executed do |c|
        operation = c.operation_response
        transaction = c.transaction_response

        # TODO: implement route check if Compliance server is available
        hash = {
          id: operation["id"],
          from: operation["source_account"],
          amount: operation["amount"],
          route: transaction["memo"],
          asset_code: transaction["asset_code"],
          asset_issuer: transaction["asset_issuer"],
          memo: transaction["memo"],
          memo_type: transaction["memo_type"],
          transaction_id: transaction["id"],
        }

        result = compare(hash, c.params)

        if result.any?
          message = [result.join(", "), "value isn't the same"].join(" ")
        elsif transaction["id"] != operation["transaction_id"]
          message = "Operation#transaction_id and transaction_id not the same"
        end

        c.fail_and_return! message if message.present?
      end

      def self.compare(hash, params)
        # TODO: implement data comparison
        params.except!(:data)

        params.keys.map do |param_key|
          param_key if params[param_key] != hash[param_key].to_s
        end.compact
      end
    end
  end
end
