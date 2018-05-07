module StellarBase
  class HorizonClient
    def get_operation(operation_id)
      response = HTTParty.get(horizon_operations_path(operation_id))

      JSON.parse(response.body) if response.code == 200
    end

    def get_transaction(transaction_id)
      response = HTTParty.get(horizon_transactions_path(transaction_id))

      JSON.parse(response.body) if response.code == 200
    end

    private

    def horizon_transactions_path(transaction_id)
      "#{base_url}/transactions/#{transaction_id}"
    end

    def horizon_operations_path(operation_id)
      "#{base_url}/operations/#{operation_id}"
    end

    def base_url
      StellarBase.configuration.horizon_url
    end
  end
end
