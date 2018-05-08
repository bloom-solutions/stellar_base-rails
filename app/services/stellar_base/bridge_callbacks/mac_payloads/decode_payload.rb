module StellarBase
  module BridgeCallbacks
    module MacPayloads
      class DecodePayload

        extend LightService::Action
        expects :callback_mac_payload
        promises :decoded_payload

        executed do |c|
          c.decoded_payload = Base64.decode64(c.callback_mac_payload)
        end
      end
    end
  end
end

