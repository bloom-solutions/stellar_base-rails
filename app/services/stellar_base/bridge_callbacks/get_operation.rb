module StellarBase
  module BridgeCallbacks
    class GetOperation
      extend LightService::Action
      expects :operation_id, :client
      promises :operation_response

      executed do |c|
        c.fail_and_return! unless c.operation_id.present?

        id = c.operation_id
        response = c.client.get_operation(id)

        c.fail_and_return! "Operation ##{id} doesn't exist" if !response.present?

        c.operation_response = response
      end
    end
  end
end
