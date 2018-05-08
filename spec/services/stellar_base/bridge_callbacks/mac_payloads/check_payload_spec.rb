require "spec_helper"

module StellarBase
  module BridgeCallbacks
    module MacPayloads

      RSpec.describe CheckPayload do
        context "no mac_payload" do
          it "fails the context" do
            result = described_class.execute(callback_mac_payload: "")
            expect(result).to be_failure
            expect(result.message).to eq "HTTP_X_PAYLOAD_MAC not present"
          end
        end

      end

    end
  end
end
