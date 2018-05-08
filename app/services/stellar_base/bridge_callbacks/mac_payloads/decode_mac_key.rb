module StellarBase
  module BridgeCallbacks
    module MacPayloads
      class DecodeMacKey

        extend LightService::Action
        promises :decoded_mac_key

        executed do |c|
          c.decoded_mac_key = Stellar::Util::StrKey.check_decode(
            :seed,
            StellarBase.configuration.bridge_callbacks_mac_key,
          )
        end
      end
    end
  end
end

