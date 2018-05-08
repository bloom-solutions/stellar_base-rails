module StellarBase
  module BridgeCallbacks
    module MacPayloads
      class EncodeParams

        extend LightService::Action
        expects :callback_params, :decoded_mac_key
        promises :encoded_params

        executed do |c|
          c.encoded_params = OpenSSL::HMAC.digest(
            "SHA256",
            c.decoded_mac_key,
            c.callback_params.to_query,
          )
        end
      end
    end
  end
end

