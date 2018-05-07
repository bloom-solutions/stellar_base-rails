module StellarBase
  module BridgeCallbacks
    module MacPayloads
      class CheckPayload

        extend LightService::Action
        expects :callback_mac_payload

        executed do |c|
          unless c.callback_mac_payload.present?
            c.fail_and_return! "HTTP_X_PAYLOAD_MAC not present"
          end
        end
      end
    end
  end
end
