module StellarBase
  class HorizonClient
    def get_operation(operation_id)
      response = HTTParty.get(base_operations_path(operation_id))

      JSON.parse(response.body) if response.code == 200
    end

    private

    def base_operations_path(operation_id)
      "#{base_url}/operations/#{operation_id}"
    end

    def base_url
      StellarBase.configuration.horizon_url
    end
  end
end
