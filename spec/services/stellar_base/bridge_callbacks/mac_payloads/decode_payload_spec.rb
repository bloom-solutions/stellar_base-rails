require "spec_helper"

module StellarBase
  module BridgeCallbacks
    module MacPayloads

      RSpec.describe DecodePayload do
        it "returns the decoded payload" do
          encoded_payload = Base64.encode64("TEST")

          result = described_class.execute(callback_mac_payload: encoded_payload)

          expect(result).to be_success
          expect(result.decoded_payload).to eq "TEST"
        end
      end

    end
  end
end
