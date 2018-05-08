module StellarBase
  module BridgeCallbacks
    module MacPayloads
      class Compare

        extend LightService::Action
        expects :encoded_params, :decoded_payload

        executed do |c|
          unless c.decoded_payload == c.encoded_params
            message = "HTTP_X_PAYLOAD_MAC and encoded raw POST doesn't match"
            c.fail_and_return! message
          end

          c.succeed!
        end
      end
    end
  end
end

