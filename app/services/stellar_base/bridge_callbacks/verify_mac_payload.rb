module StellarBase
  module BridgeCallbacks
    class VerifyMacPayload
      extend LightService::Action
      expects :callback_params, :callback_mac_payload

      executed do |c|
        callback_mac_payload = c.callback_mac_payload
        callback_params = c.callback_params

        unless callback_mac_payload.present?
          c.fail_and_return! "X_PAYLOAD_MAC not present"
        end

        encoded_callback = encode_callback(callback_params)
        decoded_payload = decode_payload(callback_mac_payload)

        unless decoded_payload == encoded_callback
          message = "X_PAYLOAD_MAC and encoded raw request body doesn't match"
          c.fail_and_return! message
        end

        c.succeed!
      end

      private

      def self.mac_key
        StellarBase.configuration.bridge_callbacks_mac_key
      end

      def self.decode_payload(payload_mac)
        Base64.decode64(payload_mac)
      end

      def self.encode_callback(callback_params)
        OpenSSL::HMAC.digest("SHA256", mac_key, callback_params.to_json)
      end
    end
  end
end

