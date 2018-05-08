module StellarBase
  module BridgeCallbacks
    class VerifyMacPayload
      extend LightService::Organizer

      def self.call(callback_mac_payload:, callback_params:)
        with(
          callback_mac_payload: callback_mac_payload,
          callback_params: callback_params,
        ).reduce(
          MacPayloads::CheckPayload,
          MacPayloads::DecodePayload,
          MacPayloads::DecodeMacKey,
          MacPayloads::EncodeParams,
          MacPayloads::Compare
        )
      end
    end
  end
end

